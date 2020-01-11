class RemoveExpiredAtFromJobOffers < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_offers, :expired_at, :datetime
  end
end
