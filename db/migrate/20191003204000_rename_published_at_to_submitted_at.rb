class RenamePublishedAtToSubmittedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :job_offers, :published_at, :submitted_at
  end
end
