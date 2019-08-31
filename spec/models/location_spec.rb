require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'validations' do
    it 'does not validate when location with the same name exists' do
      Location.create(name: 'Warszawa')

      location = Location.new(name: 'Warszawa')

      expect(location.valid?).to eq false
    end
  end
end
