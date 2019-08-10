class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :salary
      t.string :salary_type
      t.text :description
      t.string :apply_link

      t.timestamps
    end
  end
end
