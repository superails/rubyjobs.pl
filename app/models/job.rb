class Job < ApplicationRecord
  belongs_to :company
  has_many :sites
  has_many :locations, through: :sites

  accepts_nested_attributes_for :company

  attr_reader :location, :remote

  def location=(location)
    location_params = location.split(/\s*,\s*/).map do |location_name|
      {name: location_name}
    end

    self.locations = location_params.map{|location_params| Location.find_or_initialize_by(location_params)}
  end

  def remote=(value)
    locations.build([name: 'Zdalnie']) if value == "1"
  end

  def expiration_time
    (created_at + 30.days).strftime("%d.%m.%Y")
  end
end
