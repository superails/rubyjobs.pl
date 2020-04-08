class CreateJobOffersElasticSearchIndex < ActiveRecord::Migration[5.2]
  def up
    JobOffer.__elasticsearch__.create_index!
    JobOffer.import
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
