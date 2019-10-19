require 'rails_helper'

RSpec.describe RegisterApplyLinkClickJob, type: :job do
  describe '#perform_later' do
    it 'increases job_offers applu link clicks count' do
      job_offer = create(:job_offer, apply_link_clicks_count: 0)

      RegisterApplyLinkClickJob.perform_later(job_offer.id)

      expect(job_offer.reload.apply_link_clicks_count).to eq 1
    end
  end
end
