class RemoveJobOfferIdFromFacettings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :facettings, :job_offer, foreign_key: true
  end
end
