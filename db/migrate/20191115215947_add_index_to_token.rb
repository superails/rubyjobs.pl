class AddIndexToToken < ActiveRecord::Migration[5.2]
  def change
    add_index :job_offers, :token, unique: true
  end
end
