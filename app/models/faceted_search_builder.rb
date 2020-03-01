class FacetedSearchBuilder
  attr_reader :search_params

  def initialize(search_params = {})
    @search_params = search_params
  end

  def call
    all_facets = Facet.select('facets.*, COUNT(facets.id) AS job_offers_count').joins(:job_offers).where(job_offers: {state: 'published'}).group('facets.id').includes(:category).order('job_offers_count DESC, facets.name')

    default_search = all_facets.group_by(&:category).sort_by{|category, _| category.rank}.to_h

    faceted_search = default_search.keys.map do |category|
      next [category, default_search[category]] if search_params.except(category.slug.to_sym).empty?

      filtered_job_offers = JobOffer.joins(:facets)
        .where(state: 'published')
        .where(facets: {slug: search_params.except(category.slug.to_sym).values.flatten})

      filtered_facets = Facet.select('facets.*, COUNT(facets.id) AS job_offers_count')
        .joins(:job_offers)
        .where(facet_category_id: category.id) 
        .where(job_offers: {id: filtered_job_offers})
        .group('facets.id')
        .order('job_offers_count DESC, facets.name')

      filtered_facets_count = filtered_facets.map{|facet| [facet, facet.job_offers_count]}.to_h

      [
        category,
        default_search[category].map{|facet| facet.job_offers_count = filtered_facets_count[facet] || 0; facet}
      ]
    end

    faceted_search.map{|category, facets| [category, facets]}.to_h
  end
end
