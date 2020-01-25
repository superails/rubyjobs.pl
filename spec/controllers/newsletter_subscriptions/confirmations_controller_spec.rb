require 'rails_helper'

RSpec.describe NewsletterSubscriptions::ConfirmationsController, type: :controller do
  describe 'GET #create' do
    it 'changes newsletter subscription state to confirmed' do
      newsletter_subscription = create(:newsletter_subscription, email: 'marcin@rubyjobs.pl', confirm_token: '123')

      get :create, params: {confirm_token:  newsletter_subscription.confirm_token}

      expect(newsletter_subscription.reload.state).to eq 'confirmed'
    end

    it 'sends welcome email' do
      newsletter_subscription = create(:newsletter_subscription, email: 'marcin@rubyjobs.pl', confirm_token: '123')

      get :create, params: {confirm_token:  newsletter_subscription.confirm_token}

      expect(ActionMailer::Base.deliveries.last.subject).to eq 'RubyJobs.pl - dziękuję za subskrypcję przeglądu ofert.'
      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end

    it 'changes confirmation_sent_at' do
      newsletter_subscription = create(:newsletter_subscription, email: 'marcin@rubyjobs.pl', confirm_token: '123')

      get :create, params: {confirm_token:  newsletter_subscription.confirm_token}

      expect(newsletter_subscription.reload.confirmation_sent_at).to_not be_nil
    end

    it 'does not send welcome email multiple times' do
      newsletter_subscription = create(:newsletter_subscription, email: 'marcin@rubyjobs.pl', confirm_token: '123')

      get :create, params: {confirm_token:  newsletter_subscription.confirm_token}
      get :create, params: {confirm_token:  newsletter_subscription.confirm_token}

      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end
end

