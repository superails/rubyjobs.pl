require 'rails_helper'

RSpec.describe JobOffers::PublicationsController, type: :controller do
  describe 'POST #create' do
    it 'raises Pundit::NotAuthorizedError when not authorized' do
      job_offer = create(:job_offer, submitted_at: Time.zone.now)

      expect { post :create, params: {job_offer_id: job_offer.id}}.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'DELETE #destroy' do
    it 'raises Pundit::NotAuthorizedError when not authorized' do
      job_offer = create(:job_offer, submitted_at: Time.zone.now)

      expect {delete :create, params: {job_offer_id: job_offer.id}}.to raise_error(Pundit::NotAuthorizedError)
    end
  end

end



