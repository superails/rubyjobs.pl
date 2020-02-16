class FacetGenerator
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    generate_location_facets
    generate_experience_facets
  end

  private

  def generate_location_facets
    job_offer.locations.each do |location|
      location_category = FacetCategory.find_or_create_by(
        name: 'Lokalizacja',
        slug: 'location',
        rank: 10
      )

      job_offer.facets << Facet.find_or_create_by(
        name: location.name, 
        slug: location.name == 'Zdalnie' ? 'remote' : location.name.parameterize,
        category: location_category
      )
    end
  end

  def generate_experience_facets
    experience_category = FacetCategory.find_or_create_by(
      name: 'Doświadczenie',
      slug: 'experience',
      rank: 20
    )

    job_offer.facets << case job_offer.title
    when /junior|młodszy/i
      Facet.find_or_create_by(name: 'Junior', slug: 'junior', category: experience_category)
    when /senior|starszy/i
      Facet.find_or_create_by(name: 'Senior', slug: 'senior', category: experience_category)
    else
      Facet.find_or_create_by(name: 'Mid', slug: 'mid', category: experience_category)
    end
  end
end
