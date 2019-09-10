require 'rails_helper'

RSpec.describe JobOffersController, type: :controller do
  describe 'GET #index' do
    it 'assigns only published job offers to @job_offers' do
      published_job_offer = create(:job_offer, published_at: Time.zone.now)
      unpublished_job_offer = create(:job_offer, published_at: nil)

      get :index 

      expect(assigns(:job_offers).pluck(:id)).to eq [published_job_offer.id]
    end
  end

  describe 'GET #new' do
    context 'when job_offer_id saved in session' do
      it 'assigns copy of JobOffer with job_offer_id from session to @job_offer' do
        current_job_offer = create(:job_offer, 
                             title: 'Senior Ruby on Rails developer',
                             city_names: "Warszawa, Białystok",
                             remote: '1')
        session[:job_offer_id] = current_job_offer.id

        get :new

        expect(assigns(:job_offer).title).to eq 'Senior Ruby on Rails developer'
        expect(assigns(:job_offer).city_names).to eq 'Warszawa, Białystok'
        expect(assigns(:job_offer).company.name).to eq current_job_offer.company.name
        expect(assigns(:job_offer).remote).to eq '1'
      end
    end
  end

  describe 'POST #create' do
    context 'when job_offer_id saved in session' do
      it 'destroys JobOffer with id saved in session' do
        current_job_offer = create(:job_offer)
        session[:job_offer_id] = current_job_offer.id

        post :create, params: {job_offer: attributes_for(:job_offer).merge({company_attributes: attributes_for(:company)})}

        expect(session[:job_offer_id]).to_not eq current_job_offer.id
      end
    end

    it 'creates new JobOffer record' do
      post :create, params: {job_offer: attributes_for(:job_offer, title: 'Senior Ruby on Rails Developer').merge({company_attributes: attributes_for(:company)})}

      expect(JobOffer.last.title).to eq 'Senior Ruby on Rails Developer'
    end

    it 'saves new JobOffer record\'s id in session' do
      post :create, params: {job_offer: attributes_for(:job_offer, title: 'Senior Ruby on Rails Developer').merge({company_attributes: attributes_for(:company)})}

      expect(session[:job_offer_id]).to eq JobOffer.last.id
    end
  end
end
