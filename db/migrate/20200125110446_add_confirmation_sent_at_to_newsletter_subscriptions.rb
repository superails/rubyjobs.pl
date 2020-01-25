class AddConfirmationSentAtToNewsletterSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :newsletter_subscriptions, :confirmation_sent_at, :datetime
  end
end
