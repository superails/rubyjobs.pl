class RemoveUnusedIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :facettings, name: "index_facettings_on_facet_id"
  end
end
