require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validations' do
    it 'does not validate when job title is not present' do
      job = build(:job, title: "")

      expect(job.validate).to eq false
    end

    it 'does not validate when job locations is empty' do
      job = build(:job, location: '', remote: '0')

      expect(job.validate).to eq false
    end

    context 'when job is remote' do
      it 'validates when location is not present' do
        job = build(:job, location: '', remote: '1')

        expect(job.validate).to eq true
      end
    end

    context 'when job is not remote' do
      it 'validates when location is present' do
        job = build(:job, location: 'Warszawa', remote: '0')

        expect(job.validate).to eq true
      end
    end

    it 'does not validate when salary is not present' do
      job = build(:job, salary: "")

      expect(job.validate).to eq false
    end

    it 'does not validate when apply_link is not present' do
      job = build(:job, apply_link: "")

      expect(job.validate).to eq false
    end

    it 'does not validate when company is not present' do
      job = build(:job, company: nil)

      expect(job.validate).to eq false
    end

    it 'does not validate when email is not present' do
      job = build(:job, email: nil)

      expect(job.validate).to eq false
    end

    it 'does not validate when email is not in correct format' do
      job = build(:job, email: 'marcin@rubyjobs')

      expect(job.validate).to eq false
    end

    it 'validates when email is in correct format' do
      job = build(:job, email: 'marcin@rubyjobs.pl')

      expect(job.validate).to eq true
    end
  end

  describe '#remote=' do
    context 'when remote location exists in database' do 
      it 'assigns existing remote location when remote checkbox is checked' do
        create(:location, name: 'Zdalnie')
        job = Job.new

        job.remote = "1"

        expect(job.locations.map(&:name)).to include('Zdalnie')
        expect(job.locations.find{|location| location.name == 'Zdalnie'}.persisted?).to eq true
      end
    end

    context 'when remote location does not exist in database' do
      it 'builds new remote location when remote checkbox is checked' do
        job = Job.new

        job.remote = "1"

        expect(job.locations.map(&:name)).to include('Zdalnie')
        expect(job.locations.find{|location| location.name == 'Zdalnie'}.persisted?).to eq false
      end
    end

    it 'does not build remote location when remote checkbox is unchecked' do
      job = Job.new

      job.remote = "0"

      expect(job.locations.map(&:name)).to_not include('Zdalnie')
    end
  end

  describe "#location=" do
    it 'assigns locations with given names to job' do
      location = create(:location, name: 'Warszawa')

      job = Job.new

      job.location = "Warszawa, Białystok"

      expect(job.locations.map(&:name)).to eq ["Warszawa", "Białystok"]
    end

    it 'assigns locations from db when exist with given name' do
      location = create(:location, name: 'Warszawa')

      job = Job.new

      job.location = "Warszawa, Białystok"

      expect(job.locations.map(&:persisted?)).to eq [true, false]
    end
  end
end
