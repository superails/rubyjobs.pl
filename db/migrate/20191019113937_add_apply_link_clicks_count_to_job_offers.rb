class AddApplyLinkClicksCountToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :apply_link_clicks_count, :integer, default: 0
  end
end
