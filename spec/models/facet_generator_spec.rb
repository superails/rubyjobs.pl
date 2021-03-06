require 'rails_helper'

RSpec.describe FacetGenerator, type: :model do
  describe '#call' do
    it 'adds location facets to job offer' do
      job_offer = create(:job_offer, city_names: 'Warszawa, Białystok, Nowy Sącz', remote: '1', title: 'RoR Dev')

      FacetGenerator.new(job_offer).call

      expect(job_offer.facets.location.pluck(:name, :slug)).to match_array(
        [
          ['Warszawa', 'warszawa'], 
          ['Białystok', 'bialystok'], 
          ['Nowy Sącz', 'nowy-sacz'],
          ['Zdalnie', 'remote']
        ]
      )
    end

    it 'adds experience facets to job offer' do
      junior1_job_offer = create(:job_offer, remote: '1', title: 'Junior Dev')
      junior2_job_offer = create(:job_offer, remote: '1', title: 'Młodszy Dev')
      senior1_job_offer = create(:job_offer, remote: '1', title: 'Senior Dev')
      senior2_job_offer = create(:job_offer, remote: '1', title: 'Starszy Dev')
      mid_job_offer = create(:job_offer, remote: '1', title: 'RoR Dev')

      JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call}

      expect(junior1_job_offer.facets.experience.pluck(:name)).to match_array(['Junior'])
      expect(junior2_job_offer.facets.experience.pluck(:name)).to match_array(['Junior'])
      expect(senior1_job_offer.facets.experience.pluck(:name)).to match_array(['Senior'])
      expect(senior2_job_offer.facets.experience.pluck(:name)).to match_array(['Senior'])
      expect(mid_job_offer.facets.experience.pluck(:name)).to match_array(['Mid'])
    end
  end
end

