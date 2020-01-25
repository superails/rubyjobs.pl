require 'rails_helper'

RSpec.describe NewsletterSubscriptionsController, type: :controller do
  describe 'POST #create' do
    it 'creates new newsletter subscription' do
      post :create, params: {email: 'marcin@rubyjobs.pl'}

      expect(NewsletterSubscription.last.email).to eq 'marcin@rubyjobs.pl'
    end

    it 'sends confirmation email' do
      post :create, params: {email: 'marcin@rubyjobs.pl'}

      expect(ActionMailer::Base.deliveries.last.subject).to eq 'RubyJobs.pl - potwierdź subskrypcję.'
      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end

    describe 'when email already subscribed' do
      before(:each) { post :create, params: {email: 'marcin@rubyjobs.pl'} }

      it 'does not create new newsletter subscription' do
        post :create, params: {email: 'marcin@rubyjobs.pl'}

        expect(NewsletterSubscription.where(email: 'marcin@rubyjobs.pl').count).to eq 1
      end

      it 'sets flash with already subscribed message' do
        post :create, params: {email: 'marcin@rubyjobs.pl'}

        expect(flash[:notice]).to eq 'Email już jest zapisany na listę'
      end

      it 'does not send confirmation email' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end
  end
end

