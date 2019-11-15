require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  describe 'validations' do
    it 'does not validate when job_offer title is not present' do
      job_offer = build(:job_offer, title: "")

      expect(job_offer.validate).to eq false
    end

    it 'does not validate when job_offer locations is empty' do
      job_offer = build(:job_offer, city_names: '', remote: '0')

      expect(job_offer.validate).to eq false
    end

    context 'when job_offer is remote' do
      it 'validates when location is not present' do
        job_offer = build(:job_offer, city_names: '', remote: '1')

        expect(job_offer.validate).to eq true
      end
    end

    context 'when job_offer is not remote' do
      it 'validates when location is present' do
        job_offer = build(:job_offer, city_names: 'Warszawa', remote: '0')

        expect(job_offer.validate).to eq true
      end
    end

    it 'does not validate when salary is not present' do
      job_offer = build(:job_offer, salary: "")

      expect(job_offer.validate).to eq false
    end

    it 'does not validate when apply_link is not present' do
      job_offer = build(:job_offer, apply_link: "")

      expect(job_offer.validate).to eq false
    end

    it 'does not validate when company is not present' do
      job_offer = build(:job_offer, company: nil)

      expect(job_offer.validate).to eq false
    end

    it 'does not validate when email is not present' do
      job_offer = build(:job_offer, email: nil)

      expect(job_offer.validate).to eq false
    end

    it 'does not validate when email is not in correct format' do
      job_offer = build(:job_offer, email: 'marcin@rubyjob_offers')

      expect(job_offer.validate).to eq false
    end

    it 'validates when multiple emails seperated with comma' do
      job_offer = build(:job_offer, email: 'marcin@rubyjobs.pl , job@rubyjobs.pl')

      expect(job_offer.validate).to eq true
    end

    context 'when multiple emails' do
      it 'does not validate untill all are in correct format' do
        job_offer = build(:job_offer, email: 'marcin@rubyjobs , job@rubyjobs.pl')

        expect(job_offer.validate).to eq false
      end
    end


    it 'validates when email is in correct format' do
      job_offer = build(:job_offer, email: 'marcin@rubyjob_offers.pl')

      expect(job_offer.validate).to eq true
    end
  end

  describe 'callbacks' do
    it 'generates random token on save' do
      job_offer = create(:job_offer)

      expect(job_offer.token).to_not be_nil
    end

  end

  describe '#remote=' do
    context 'when remote location exists in database' do 
      it 'assigns existing remote location when remote checkbox is checked' do
        create(:location, name: 'Zdalnie')
        job_offer = JobOffer.new

        job_offer.remote = "1"

        expect(job_offer.locations.map(&:name)).to include('Zdalnie')
        expect(job_offer.locations.find{|location| location.name == 'Zdalnie'}.persisted?).to eq true
      end
    end

    context 'when remote location does not exist in database' do
      it 'builds new remote location when remote checkbox is checked' do
        job_offer = JobOffer.new

        job_offer.remote = "1"

        expect(job_offer.locations.map(&:name)).to include('Zdalnie')
        expect(job_offer.locations.find{|location| location.name == 'Zdalnie'}.persisted?).to eq false
      end
    end

    it 'does not build remote location when remote checkbox is unchecked' do
      job_offer = JobOffer.new

      job_offer.remote = "0"

      expect(job_offer.locations.map(&:name)).to_not include('Zdalnie')
    end

    it 'removes remote location when remote checkbox is unchecked' do
      job_offer = JobOffer.new
      job_offer.locations << Location.create(name: 'Zdalnie')

      job_offer.remote = "0"

      expect(job_offer.locations.map(&:name)).to_not include('Zdalnie')
    end
  end

  describe "#city_names=" do
    it 'assigns locations with given names to job_offer' do
      location = create(:location, name: 'Warszawa')

      job_offer = JobOffer.new

      job_offer.city_names = "Warszawa, Białystok"

      expect(job_offer.locations.map(&:name)).to eq ["Warszawa", "Białystok"]
    end

    it 'assigns locations from db when exist with given name' do
      location = create(:location, name: 'Warszawa')

      job_offer = JobOffer.new

      job_offer.city_names = "Warszawa, Białystok"

      expect(job_offer.locations.map(&:persisted?)).to eq [true, false]
    end
  end
end
