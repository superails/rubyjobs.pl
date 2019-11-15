class AddTokenToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :token, :string
    add_index :job_offers, :token, unique: true
  end
end
