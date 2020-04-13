class DropFacetTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :facettings
    drop_table :facets
  end
end
