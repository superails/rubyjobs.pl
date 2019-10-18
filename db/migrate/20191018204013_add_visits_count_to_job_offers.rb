class AddVisitsCountToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :visits_count, :integer, default: 0
  end
end
