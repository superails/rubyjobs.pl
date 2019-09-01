require 'rails_helper'

RSpec.describe Job, type: :model do
  describe "#remote=" do
    it 'builds remote location when remote checkbox is checked' do
      job = Job.new

      job.remote = "1"

      expect(job.locations.map(&:name)).to include('Zdalnie')
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
