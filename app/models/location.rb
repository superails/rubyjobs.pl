class Location < ApplicationRecord
  has_many :sites
  has_many :job_offers, through: :sites

  validates :name, uniqueness: true
end
