class FillStateColumn < ActiveRecord::Migration[5.2]
  def up
    JobOffer.where.not(expired_at: nil).update_all(state: 'expired')
    JobOffer.where.not(published_at: nil).where(expired_at: nil).update_all(state: 'published')
    JobOffer.where(published_at: nil).where.not(submitted_at: nil).update_all(state: 'submitted')
    JobOffer.where(state: nil).update_all(state: 'created')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
