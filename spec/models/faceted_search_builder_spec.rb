require 'rails_helper'

RSpec.describe FacetedSearchBuilder, type: :model do
  describe '#call' do
    it 'builds search with all facets and categories associated with published jobs' do
      create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '0', title: 'Junior Dev')
      create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev')
      create(:job_offer, state: 'submitted', city_names: 'Warszawa', remote: '1', title: 'Senior Dev')
      JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call }

      faceted_search = FacetedSearchBuilder.new.call.map do |facet_category, facets| 
        [facet_category.slug, facets.map{|facet| [facet.slug, facet.job_offers_count]}]
      end.to_h
      
      expect(faceted_search).to eq(
        {
          "location"=>[["warszawa", 2], ["bialystok", 1]], 
          "experience"=>[["junior", 1], ["mid", 1]]
        })
    end

    context 'with search param' do
      it 'shows correct counts for each facet' do
        create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '0', title: 'Junior Dev')
        create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev')
        create(:job_offer, state: 'submitted', city_names: 'Warszawa', remote: '1', title: 'Senior Dev')
        JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call }
        search_params = {experience: ['junior']}

        faceted_search = FacetedSearchBuilder.new(search_params).call.map do |facet_category, facets| 
          [facet_category.slug, facets.map{|facet| [facet.slug, facet.job_offers_count]}]
        end.to_h

        expect(faceted_search).to eq(
          {
            "location"=>[["warszawa", 1], ["bialystok", 1]], 
            "experience"=>[["junior", 1], ["mid", 1]]
          })
      end
    end
  end
end
