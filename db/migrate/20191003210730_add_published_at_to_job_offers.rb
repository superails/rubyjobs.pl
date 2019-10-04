class AddPublishedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :published_at, :datetime
  end
end
