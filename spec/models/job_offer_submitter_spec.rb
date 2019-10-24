require 'rails_helper'

RSpec.describe JobOfferSubmitter, type: :model do
  describe "#call" do
    it "sets up submitted_at to current time" do 
      job_offer = create(:job_offer)

      JobOfferSubmitter.new(job_offer).call

      expect(job_offer.reload.submitted_at).to_not be_nil
    end

    it "sends submit notification email to provided emails" do
      job_offer = create(:job_offer, email: 'marcin@rubyjobs.pl , jobs@rubyjobs.pl')

      JobOfferSubmitter.new(job_offer).call

      expect(ActionMailer::Base.deliveries.last.to).to match_array(['marcin@rubyjobs.pl', 'jobs@rubyjobs.pl'])
    end

    context 'when with_email option set to false' do
      it 'does not sends submit email to user that created this job offer' do
        job_offer = create(:job_offer, email: 'marcin@rubyjobs.pl , jobs@rubyjobs.pl')

        JobOfferSubmitter.new(job_offer, with_email: false).call

        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

