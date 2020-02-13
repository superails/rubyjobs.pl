class CreateFacets < ActiveRecord::Migration[5.2]
  def change
    create_table :facets do |t|
      t.string :name
      t.string :slug
      t.integer :rank
      t.references :facet_category, foreign_key: true

      t.timestamps
    end
  end
end
