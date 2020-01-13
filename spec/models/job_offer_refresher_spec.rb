require 'rails_helper'

RSpec.describe JobOfferRefresher, type: :model do
  describe '#call' do
    it 'updates published_at to current time' do
      job_offer = create(:job_offer, published_at: Time.zone.now - 1.day)
      Timecop.freeze('2020-01-11')

      JobOfferRefresher.new(job_offer).call

      expect(job_offer.reload.published_at).to eq Time.zone.now

      Timecop.return
    end

    it 'sends emails with stats' do
      job_offer = create(:job_offer, email: 'marcin@rubyjobs.pl', published_at: Time.zone.now - 1.day)

      JobOfferRefresher.new(job_offer).call

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']


    end
  end
end

