class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.references :job, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
