class Job < ApplicationRecord
  belongs_to :company
  has_many :sites
  has_many :locations, through: :sites

  accepts_nested_attributes_for :company

  scope :published, -> { where.not(published_at: nil) }

  def location
    locations.reject{|location| location.name == 'Zdalnie'}.map(&:name).join(', ')
  end

  def location=(location)
    location_params = location.split(/\s*,\s*/).map do |location_name|
      {name: location_name}
    end

    self.locations = location_params.map{|location_params| Location.find_or_initialize_by(location_params)}
  end

  def remote
    locations.select{|location| location.name == 'Zdalnie'}.count > 0 ? '1' : '0'
  end

  def remote=(value)
    locations.build([name: 'Zdalnie']) if value == "1"
  end

  def expiration_time
    (created_at + 30.days).strftime("%d.%m.%Y")
  end
end
