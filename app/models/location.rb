class Location < ApplicationRecord
  has_many :sites
  has_many :jobs, through: :sites
end
