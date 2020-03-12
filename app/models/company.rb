class Company < ApplicationRecord
  has_many :job_offers
  has_many :facettings, as: :facetable
  has_many :facets, through: :facettings

  has_one_attached :logo

  validates :name, presence: true
  validates :name, uniqueness: true
end
