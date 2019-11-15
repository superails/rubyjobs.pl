class AddTokenToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :token, :string
  end
end
