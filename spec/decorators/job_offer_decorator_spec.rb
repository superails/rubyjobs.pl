require 'rails_helper'

RSpec.describe JobOfferDecorator do
  describe '#time_since_publication' do
    it 'displays NEW for first 24h since publication' do
      job_offer = JobOffer.new(published_at: Time.zone.now - 23.hours)

      expect(job_offer.decorate.time_since_publication).to eq "NEW"
    end

    it 'displays time in days for first 30 days since publication' do
      job_offer = JobOffer.new(published_at: Time.zone.now - 29.days)

      expect(job_offer.decorate.time_since_publication).to eq "29d"
    end

    it 'displays time in months for more than 30 days since publication' do
      job_offer = JobOffer.new(published_at: Time.zone.now - 3.months - 5.days)

      expect(job_offer.decorate.time_since_publication).to eq "3m"
    end

    it 'displays NEW for job offers that has not been published yet' do
      job_offer = JobOffer.new(published_at: nil)

      expect(job_offer.decorate.time_since_publication).to eq "NEW"
    end

  end
end
