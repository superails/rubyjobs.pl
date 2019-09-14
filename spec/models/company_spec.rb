require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations' do
    it 'does not validate when name is not present' do
      company = build(:company, name: '')

      expect(company.validate).to eq false
    end

    it 'does not validate when name is not unique' do
      create(:company, name: 'Firma')
      company = build(:company, name: 'Firma')

      expect(company.validate).to eq false
    end
  end
end
