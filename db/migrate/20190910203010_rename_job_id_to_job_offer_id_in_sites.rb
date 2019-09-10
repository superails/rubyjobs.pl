class RenameJobIdToJobOfferIdInSites < ActiveRecord::Migration[5.2]
  def change
    rename_column :sites, :job_id, :job_offer_id
  end
end
