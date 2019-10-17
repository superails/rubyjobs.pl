require 'rails_helper'

RSpec.describe JobOfferSubmitter, type: :model do
  describe "#call" do
    it "sets up submitted_at to current time" do 
      job_offer = create(:job_offer)

      JobOfferSubmitter.new(job_offer).call

      expect(job_offer.reload.submitted_at).to_not be_nil
    end

    it "sends submit email to user that created this job offer" do
      job_offer = create(:job_offer, email: 'marcin@rubyjobs.pl')

      JobOfferSubmitter.new(job_offer).call

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end
  end
end

