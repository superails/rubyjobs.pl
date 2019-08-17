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

    locations.build(location_params)
  end

  def remote=(value)
    locations.build([name: 'Zdalnie'])
  end

  def autosave_associated_records_for_locations
    new_locations = locations.reject{|location| Location.find_by(name: location.name)}
    existing_locations = Location.where(name: (locations - new_locations).map(&:name))

    new_locations.each(&:save!)
    self.locations << existing_locations + new_locations
  end

  def expiration_time
    (created_at + 30.days).strftime("%d.%m.%Y")
  end
end
