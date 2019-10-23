require 'rails_helper'

RSpec.describe JobOffers::SubmissionsController, type: :controller do
  describe 'POST #create' do
    it 'destroys current job_offer_id in session' do
      job_offer = create(:job_offer)
      session[:job_offer_id] = job_offer.id

      post :create

      expect(session[:job_offer_id]).to be_nil
    end

    it "sets up submitted_at" do 
      job_offer = create(:job_offer)
      session[:job_offer_id] = job_offer.id

      post :create

      expect(job_offer.reload.submitted_at).to_not be_nil
    end

    it 'sends email to job offer creator' do
      job_offer = create(:job_offer,  email: 'marcin@rubyjobs.pl')
      session[:job_offer_id] = job_offer.id

      post :create

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end

    context 'when submitted by admin user' do
      before :each do
        admin = create(:user, admin: true)
        sign_in admin
        job_offer = create(:job_offer,  email: 'marcin@rubyjobs.pl')
        session[:job_offer_id] = job_offer.id
      end
      it 'does not send submit email to job offer creator' do

        post :create

        expect(ActionMailer::Base.deliveries.map(&:subject)).to_not include "Twoje ogłoszenie zostało dodane i czeka na publikację"
      end

      it 'sends publish email to job offer creator' do
        post :create

        expect(ActionMailer::Base.deliveries.map(&:subject)).to include "Twoje ogłoszenie zostało opublikowane"
      end

      it 'sets up submitted_at' do
        post :create

        expect(JobOffer.last.submitted_at).to_not be_nil
      end

      it 'sets up published_at' do
        post :create

        expect(JobOffer.last.published_at).to_not be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow to perform action when not authorized' do
      job_offer = create(:job_offer, submitted_at: Time.zone.now)

      expect {delete :destroy, params: {job_offer_id: job_offer.id}}.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'revokes job offer submission' do
      admin = create(:user, admin: true)
      sign_in admin

      job_offer = create(:job_offer, submitted_at: Time.zone.now)

      delete :destroy, params: {job_offer_id: job_offer.id}

      expect(job_offer.reload).to_not be_submitted
    end
  end

end
