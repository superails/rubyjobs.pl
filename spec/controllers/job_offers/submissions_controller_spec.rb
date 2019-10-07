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
  end

end
