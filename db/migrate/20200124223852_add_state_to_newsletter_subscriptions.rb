class AddStateToNewsletterSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :newsletter_subscriptions, :state, :string
  end
end
