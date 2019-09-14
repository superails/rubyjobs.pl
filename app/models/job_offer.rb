class JobOffer < ApplicationRecord
  belongs_to :company
  has_many :sites
  has_many :locations, through: :sites

  accepts_nested_attributes_for :company

  scope :published, -> { where.not(published_at: nil) }

  validates :title, :locations, :salary, :apply_link, :email, presence: true
  validates :email, format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  def city_names
    locations.reject{|location| location.name == 'Zdalnie'}.map(&:name).join(', ')
  end

  def city_names=(city_names)
    location_params = city_names.split(/\s*,\s*/).map do |city_name|
      {name: city_name}
    end

    locations << location_params.map{|location_params| Location.find_or_initialize_by(location_params)}
  end

  def remote
    locations.select{|location| location.name == 'Zdalnie'}.count > 0 ? '1' : '0'
  end

  def remote=(value)
    locations << Location.find_or_initialize_by(name: 'Zdalnie') if value == "1"
  end

  def company_attributes=(attributes)
    self.company = Company.find_or_initialize_by(name: attributes[:name])
  end

  def expiration_time
    (created_at + 30.days).strftime("%d.%m.%Y")
  end
end
