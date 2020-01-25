class NewsletterSubscription < ApplicationRecord
  before_create :generate_confirm_token

  private

  def generate_confirm_token
    return if confirm_token

    self.confirm_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless NewsletterSubscription.exists?(confirm_token: random_token)
    end
  end
end
