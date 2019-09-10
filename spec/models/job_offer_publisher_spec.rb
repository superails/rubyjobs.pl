require 'rails_helper'

RSpec.describe JobOfferPublisher, type: :model do
  describe "#call" do
    it "sets up published_at to current time" do 
      job_offer = create(:job_offer)

      JobOfferPublisher.new(job_offer).call

      expect(job_offer.reload.published_at).to_not be_nil
    end

    it "sends summary email to user that created this job offer" do
      job_offer = create(:job_offer, email: 'marcin@rubyjob_offers.pl')

      JobOfferPublisher.new(job_offer).call

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjob_offers.pl']
    end
  end
end
