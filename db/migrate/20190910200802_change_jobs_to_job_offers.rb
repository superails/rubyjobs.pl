class ChangeJobsToJobOffers < ActiveRecord::Migration[5.2]
  def change
    rename_table :jobs, :job_offers
  end
end
