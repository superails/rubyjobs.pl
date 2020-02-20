require 'rails_helper'

RSpec.describe FacetedSearchBuilder, type: :model do
  describe '#call' do
    it 'builds search with all facets and categories associated with published jobs' do
      create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '0', title: 'Junior Dev')
      create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev')
      create(:job_offer, state: 'submitted', city_names: 'Warszawa', remote: '1', title: 'Senior Dev')
      JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call }

      faceted_search = FacetedSearchBuilder.new.call

      expect(faceted_search).to eq({
        'location' => [['Warszawa', 2, 'warszawa' ], ['Białystok', 1, 'bialystok']],
        'experience' => [['Junior', 1, 'junior'], ['Mid', 1, 'mid']]
      })
    end

    context 'with search param' do
      it 'shows correct counts for each facet' do
        create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '0', title: 'Junior Dev')
        create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev')
        create(:job_offer, state: 'submitted', city_names: 'Warszawa', remote: '1', title: 'Senior Dev')
        JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call }

        faceted_search = FacetedSearchBuilder.new({experience: ['junior']}).call

        expect(faceted_search).to eq({
          'location' => [['Warszawa', 1, 'warszawa'], ['Białystok', 1, 'bialystok']],
          'experience' => [['Junior', 1, 'junior'], ['Mid', 1, 'mid']]
        })
      end
    end
  end
end
