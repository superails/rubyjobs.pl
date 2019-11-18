class AddStateToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :state, :string
  end
end
