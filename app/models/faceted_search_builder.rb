class FacetedSearchBuilder
  attr_reader :search_params

  def initialize(search_params = {})
    @search_params = search_params
  end

  def call
    Facet.find_by_sql(query).group_by(&:category_slug)
  end

  private

  def query
    query = <<-SQL
      WITH all_facets AS (
        SELECT 
          facets.slug, 
          facets.name,
          facet_categories.slug AS category_slug, 
          facet_categories.rank AS category_rank,
          job_offers.id AS job_offer_id
        FROM facets
        INNER JOIN facettings ON facettings.facet_id = facets.id
        INNER JOIN job_offers ON job_offers.id = facettings.facetable_id AND facettings.facetable_type = 'JobOffer'
        INNER JOIN facet_categories ON facet_categories.id = facets.facet_category_id
        WHERE job_offers.state = 'published'

        UNION ALL

        SELECT 
          facets.slug, 
          facets.name,
          facet_categories.slug AS category_slug, 
          facet_categories.rank AS category_rank,
          job_offers.id AS job_offer_id
        FROM facets
        INNER JOIN facettings ON facettings.facet_id = facets.id
        INNER JOIN companies ON companies.id = facettings.facetable_id AND facettings.facetable_type = 'Company'
        INNER JOIN job_offers ON job_offers.company_id = companies.id
        INNER JOIN facet_categories ON facet_categories.id = facets.facet_category_id
        WHERE job_offers.state = 'published'
      ), all_facets_with_counts AS (
        SELECT 
          all_facets.slug, 
          all_facets.name,
          all_facets.category_slug, 
          all_facets.category_rank,
          COUNT(all_facets.job_offer_id) AS job_offers_count
        FROM all_facets
        GROUP BY 
          all_facets.slug, 
          all_facets.name,
          all_facets.category_slug, 
          all_facets.category_rank
      )
    SQL

    if search_params.empty?
      query += <<-SQL
        SELECT * 
        FROM all_facets_with_counts
        ORDER BY 
          category_rank DESC,
          job_offers_count DESC,
          slug DESC
      SQL
    else
      search_categories = 
        search_params.keys.map{|facet_category| "\"#{facet_category}\""}.join(', ')

      search_query = <<-SQL
        SELECT 
          slug, 
          name,
          category_slug, 
          category_rank,
          CASE WHEN array_length(array_remove('{#{search_categories}}', category_slug), 1) > 0
               THEN 0
               ELSE all_facets_with_counts.job_offers_count
          END AS job_offers_count,
          all_facets_with_counts.job_offers_count AS facet_rank
        FROM all_facets_with_counts
      SQL


      search_params.each do |facet_category_slug, facet_slugs|
        search_slugs = facet_slugs.map{|facet_slug| "'#{facet_slug}'"}.join(', ')

        search_query += <<-SQL
          UNION ALL

          SELECT 
            all_facets.slug, 
            all_facets.name,
            all_facets.category_slug, 
            all_facets.category_rank,
            COUNT(all_facets.job_offer_id) AS job_offers_count,
            0 AS facet_rank
          FROM all_facets
          WHERE all_facets.category_slug != '#{facet_category_slug}'
          AND job_offer_id IN (
            SELECT DISTINCT all_facets.job_offer_id 
            FROM all_facets 
            WHERE all_facets.slug IN (#{search_slugs})
          )
          GROUP BY 
            all_facets.slug, 
            all_facets.name,
            all_facets.category_slug,
            all_facets.category_rank
        SQL
      end

      query += <<-SQL
        SELECT 
          slug, 
          name,
          category_slug, 
          category_rank, 
          MAX(search_facets.job_offers_count) AS job_offers_count,
          MAX(search_facets.facet_rank) AS facet_rank
        FROM (
          #{search_query}
        ) AS search_facets
        GROUP BY slug, name, category_slug, category_rank
        ORDER BY category_rank DESC, facet_rank DESC, slug DESC
      SQL
    end

    query
  end
end
