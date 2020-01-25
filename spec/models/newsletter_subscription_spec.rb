require 'rails_helper'

RSpec.describe NewsletterSubscription, type: :model do
  describe 'callbacks' do
    it 'generates random confirm token on save' do
      subscription = create(:newsletter_subscription)

      expect(subscription.confirm_token).to_not be_nil
    end
  end
end
