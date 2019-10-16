class AddExpiredAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :expired_at, :datetime
  end
end
