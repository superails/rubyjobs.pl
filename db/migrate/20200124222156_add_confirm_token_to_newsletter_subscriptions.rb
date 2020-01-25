class AddConfirmTokenToNewsletterSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :newsletter_subscriptions, :confirm_token, :string
  end
end
