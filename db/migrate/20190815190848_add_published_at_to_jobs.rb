class AddPublishedAtToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :published_at, :datetime
  end
end
