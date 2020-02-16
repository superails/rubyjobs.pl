class Facet < ApplicationRecord
  belongs_to :category, class_name: 'FacetCategory', foreign_key: 'facet_category_id'
  has_many :facettings
  has_many :job_offers, through: :facettings
end
