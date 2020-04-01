require 'rails_helper'

RSpec.describe JobOfferDecorator do
  describe '#location_names' do
    it 'displays location names sorted remote first and the rest alphabetically' do
      job_offer = JobOffer.new

      location_names = %w(Warszawa Białystok Gdynia Zdalnie)
      location_names.each{|location_name| create(:location, name: location_name)}

      job_offer.locations = Location.all

      expect(job_offer.decorate.location_names).to eq "Zdalnie, Białystok, Gdynia, Warszawa"
    end
  end
end
