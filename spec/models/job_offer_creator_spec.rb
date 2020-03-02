require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  describe '#call' do
    it 'creates job offer' do
      job_offer_params = 
        attributes_for(:job_offer, title: 'Junior RoR Dev')
        .merge({company_attributes: attributes_for(:company, name: 'Firma')})

      job_offer = JobOfferCreator.new(job_offer_params).call

      expect(JobOffer.last.title).to eq 'Junior RoR Dev'
    end

    it 'generate facets for created job offer' do 
      job_offer_params = 
        attributes_for(:job_offer, title: 'Junior RoR Dev')
        .merge({company_attributes: attributes_for(:company, name: 'Firma')})

      job_offer = JobOfferCreator.new(job_offer_params).call

      expect(job_offer.facets.pluck(:slug)).to include('junior')
    end

    context 'when failed to create job offer' do
      it 'returns false' do
        job_offer_params = 
          attributes_for(:job_offer, title: '')
          .merge({company_attributes: attributes_for(:company, name: 'Firma')})

        expect(JobOfferCreator.new(job_offer_params).call).to eq false
      end
    end
  end
end
