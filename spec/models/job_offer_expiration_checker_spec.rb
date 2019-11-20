require 'rails_helper'

RSpec.describe JobOfferExpirationChecker, type: :model do
  describe '#call' do
    it 'sends email to all expired job offers' do
      create(:job_offer, 
             state: 'published',
             published_at: Time.zone.now - 31.days,
             submitted_at: Time.zone.now - 32.days,
             email: 'marcin1@rubyjobs.pl'
            )

      create(:job_offer, 
             state: 'published',
             published_at: Time.zone.now - 29.days,
             submitted_at: Time.zone.now - 28.days,
             email: 'marcin2@rubyjobs.pl'
            )

      JobOfferExpirationChecker.new.call

      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to eq ['marcin1@rubyjobs.pl']
    end

    it 'sets expired_at to current time' do
      job_offer1 = create(:job_offer, 
             state: 'published',
             published_at: Time.zone.now - 31.days,
             submitted_at: Time.zone.now - 32.days,
             email: 'marcin1@rubyjobs.pl',
             expired_at: nil
            )

      job_offer2 = create(:job_offer, 
             state: 'published',
             published_at: Time.zone.now - 29.days,
             submitted_at: Time.zone.now - 28.days,
             email: 'marcin2@rubyjobs.pl',
             expired_at: nil
            )

      JobOfferExpirationChecker.new.call

      expect(job_offer1.reload.expired_at).to_not be_nil
      expect(job_offer2.reload.expired_at).to be_nil
    end

    it 'does not send email when job is in expired state' do
      job_offer1 = create(:job_offer, 
                          state: 'published',
                          published_at: Time.zone.now - 31.days,
                          submitted_at: Time.zone.now - 32.days,
                          email: 'marcin1@rubyjobs.pl',
                          expired_at: nil
                         )

      job_offer2 = create(:job_offer, 
                          state: 'expired',
                          published_at: Time.zone.now - 31.days,
                          submitted_at: Time.zone.now - 32.days,
                          email: 'marcin2@rubyjobs.pl',
                          expired_at: Time.zone.now
                         )

      JobOfferExpirationChecker.new.call

      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to eq ['marcin1@rubyjobs.pl']
    end
  end
end
