class Facet < ApplicationRecord
  belongs_to :category, class_name: 'FacetCategory', foreign_key: 'facet_category_id'
  has_many :facettings
  has_many :job_offers, through: :facettings, source: :facetable, source_type: 'JobOffer'
  has_many :companies, through: :facettings, source: :facetable, source_type: 'JobOffer'

  scope :location, -> { joins(:category).where(facet_categories: {slug: 'location'}) } 
  scope :experience, -> { joins(:category).where(facet_categories: {slug: 'experience'}) } 
end
