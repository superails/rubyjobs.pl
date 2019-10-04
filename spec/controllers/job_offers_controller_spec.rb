require 'rails_helper'

RSpec.describe JobOffersController, type: :controller do
  describe 'GET #index' do
    context 'when regular user' do
      let(:user) { create(:user, admin: false) }

      before :each do
        sign_in user
      end

      it 'assigns only published job offers to @job_offers' do
        published_job_offer = create(:job_offer, published_at: Time.zone.now)
        unpublished_job_offer = create(:job_offer, published_at: nil)

        get :index 

        expect(assigns(:job_offers).pluck(:id)).to eq [published_job_offer.id]
      end

      it 'assigns job offers ordered by publication date' do
        old_job_offer = create(:job_offer, published_at: Time.zone.now - 1.hour)
        new_job_offer = create(:job_offer, published_at: Time.zone.now)

        get :index

        expect(assigns(:job_offers).first).to eq new_job_offer
      end
    end

    describe 'when admin user' do
      let(:user) { create(:user, admin: true) }

      before :each do
        sign_in user
      end

      it 'assigns submitted job offers to @job_offers' do
        submitted_job_offer = create(:job_offer, submitted_at: Time.zone.now)
        unsubmitted_job_offer = create(:job_offer, submitted_at: nil)

        get :index 

        expect(assigns(:job_offers).pluck(:id)).to eq [submitted_job_offer.id]
      end
      it 'assigns job offers ordered by submission date and publication date' do
        new_published_job = create(:job_offer, submitted_at: Time.zone.now, published_at: Time.zone.now)
        old_published_job = create(:job_offer, submitted_at: Time.zone.now - 1.day, published_at: Time.zone.now - 1.day)
        older_submitted_job = create(:job_offer, submitted_at: Time.zone.now - 2.day, published_at: nil)
        oldest_submitted_job = create(:job_offer, submitted_at: Time.zone.now - 3.day, published_at: nil)

        get :index

        expect(assigns(:job_offers).pluck(:id)).to eq [ older_submitted_job, oldest_submitted_job, new_published_job, old_published_job ].map(&:id) end
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

    context 'when invalid job offer params' do
      it 'rerenders #new view' do
        post :create, params: {job_offer: attributes_for(:job_offer, title: '')}

        expect(response).to render_template(:new)
      end
    end

    context 'when company exists in db' do
      it 'assigns job offer to existing company' do
        company = create(:company, name: 'Firma')

        post :create, params: {
          job_offer: attributes_for(:job_offer, title: 'Senior Ruby on Rails Developer').
          merge({company_attributes: attributes_for(:company, name: 'Firma')})
        }

        expect(JobOffer.last.company).to eq company
      end
    end
  end
end
