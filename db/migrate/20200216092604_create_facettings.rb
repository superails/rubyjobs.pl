class CreateFacettings < ActiveRecord::Migration[5.2]
  def change
    create_table :facettings do |t|
      t.references :job_offer, foreign_key: true
      t.references :facet, foreign_key: true

      t.timestamps
    end
  end
end
