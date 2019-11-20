require 'rails_helper'

RSpec.describe JobOfferPublisher, type: :model do
  describe "#call" do
    it "sets up published_at to current time" do 
      job_offer = create(:job_offer)

      JobOfferPublisher.new(job_offer).call

      expect(job_offer.reload.published_at).to_not be_nil
    end

    context "when submitted_at is empty" do
      it "sets up submitted_at to current time" do
        job_offer = create(:job_offer)

        JobOfferPublisher.new(job_offer).call

        expect(job_offer.reload.submitted_at).to_not be_nil
      end
    end

    it "sends summary email to user that created this job offer" do
      job_offer = create(:job_offer, email: 'marcin@rubyjob_offers.pl')

      JobOfferPublisher.new(job_offer).call

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjob_offers.pl']
    end

    it "clears visits count" do
      job_offer = create(:job_offer, visits_count: 10, email: 'marcin@rubyjob_offers.pl')

      JobOfferPublisher.new(job_offer).call

      expect(job_offer.reload.visits_count).to eq 0
    end

    it "clears apply_link_clicks_count" do
      job_offer = create(:job_offer, apply_link_clicks_count: 10, email: 'marcin@rubyjob_offers.pl')

      JobOfferPublisher.new(job_offer).call

      expect(job_offer.reload.apply_link_clicks_count).to eq 0
    end
  end
end
