require 'rails_helper'

RSpec.describe RegisterJobOfferVisitJob, type: :job do
  describe '#perform_later' do
    it 'increases job_offer visits count' do
      job_offer = create(:job_offer, visits_count: 0)

      RegisterJobOfferVisitJob.perform_later(job_offer.id)

      expect(job_offer.reload.visits_count).to eq 1
    end
  end
end
