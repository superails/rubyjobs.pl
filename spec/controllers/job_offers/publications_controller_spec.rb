require 'rails_helper'

RSpec.describe JobOffers::PublicationsController, type: :controller do
  describe 'POST #create' do
    it 'does not allow to perform action when not authorized' do
      job_offer = create(:job_offer, submitted_at: Time.zone.now)

      expect { post :create, params: {token: job_offer.token}}.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'sends email to job offer creator' do
      admin = create(:user, admin: true)
      sign_in admin

      job_offer = create(:job_offer, submitted_at: Time.zone.now, email: 'marcin@rubyjobs.pl')

      post :create, params: {token: job_offer.token}

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end

    it 'sets job_offer as published' do
      admin = create(:user, admin: true)
      sign_in admin

      job_offer = create(
        :job_offer, 
        submitted_at: Time.zone.now, 
        email: 'marcin@rubyjobs.pl',
        published_at: nil
      )

      post :create, params: {token: job_offer.token}

      expect(job_offer.reload).to be_published
    end
  end
end



