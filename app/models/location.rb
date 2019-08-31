class Location < ApplicationRecord
  has_many :sites
  has_many :jobs, through: :sites

  validates :name, uniqueness: true
end
