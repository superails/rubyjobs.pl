class Facetting < ApplicationRecord
  belongs_to :facetable, polymorphic: true
  belongs_to :facet
end
