require 'rails_helper'

RSpec.describe JobDecorator do
  describe '#time_since_publication' do
    it 'displays NEW for first 24h since publiction' do
      job = Job.new(published_at: Time.zone.now - 23.hours)

      expect(job.decorate.time_since_publication).to eq "NEW"
    end

    it 'displays d for first 30 days since publication' do
      job = Job.new(published_at: Time.zone.now - 29.days)

      expect(job.decorate.time_since_publication).to eq "29d"
    end

    it 'display m for more than 30 days since publication' do
      job = Job.new(published_at: Time.zone.now - 3.months - 5.days)

      expect(job.decorate.time_since_publication).to eq "3m"
    end

    it 'displays NEW for jobs that has not been published yet' do
      job = Job.new(published_at: nil)

      expect(job.decorate.time_since_publication).to eq "NEW"
    end

  end
end
