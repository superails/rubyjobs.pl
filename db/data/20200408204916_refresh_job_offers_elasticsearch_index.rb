class RefreshJobOffersElasticsearchIndex < ActiveRecord::Migration[5.2]
  def up
    JobOffer.__elasticsearch__.create_index! force: true
    JobOffer.import
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
