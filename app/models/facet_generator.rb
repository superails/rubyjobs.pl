class FacetGenerator
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    job_offer.facets.destroy_all
    generate_location_facets
    generate_experience_facets
  end

  private

  def generate_location_facets
    job_offer.locations.uniq.each do |location|
      location_category = FacetCategory.find_or_create_by(
        name: 'Lokalizacja',
        slug: 'location',
        rank: 50
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
      rank: 40
    )

    if job_offer.title =~ /junior|młodszy/i
      job_offer.facets << Facet.find_or_create_by(name: 'Junior', slug: 'junior', category: experience_category)
    end

    if job_offer.title =~ /senior|starszy|lead|cto/i
      job_offer.facets << Facet.find_or_create_by(name: 'Senior', slug: 'senior', category: experience_category)
    end 

    if job_offer.title =~ /Mid/i || job_offer.facets.experience.empty?
      job_offer.facets << Facet.find_or_create_by(name: 'Mid', slug: 'mid', category: experience_category)
    end 
  end
end
