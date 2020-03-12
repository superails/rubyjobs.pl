class AddFacetableToFacettings < ActiveRecord::Migration[5.2]
  def change
    add_reference :facettings, :facetable, polymorphic: true, index: true
  end
end
