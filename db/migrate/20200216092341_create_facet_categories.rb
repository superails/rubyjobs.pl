class CreateFacetCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :facet_categories do |t|
      t.string :name
      t.string :slug
      t.integer :rank

      t.timestamps
    end
  end
end
