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
end
