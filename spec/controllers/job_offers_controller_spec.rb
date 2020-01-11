require 'rails_helper'

RSpec.describe JobOffersController, type: :controller do
  describe 'GET #index' do
    context 'when regular user' do
      let(:user) { create(:user, admin: false) }

      before :each do
        sign_in user
      end

      it 'assigns only published job offers to @job_offers' do
        published_job_offer = create(:job_offer, state: 'published', published_at: Time.zone.now)
        unpublished_job_offer = create(:job_offer, state: 'created', published_at: nil)

        get :index 

        expect(assigns(:job_offers).pluck(:id)).to eq [published_job_offer.id]
      end

      it 'does not assign closed job offers to @job_offers' do
        closed_job_offer = create(:job_offer, published_at: Time.zone.now - 1.day, state: 'closed')

        get :index

        expect(assigns(:job_offers).pluck(:id)).to eq []
      end

      it 'assigns job offers ordered by publication date' do
        old_job_offer = create(:job_offer, state: 'published', published_at: Time.zone.now - 1.hour)
        new_job_offer = create(:job_offer, state: 'published', published_at: Time.zone.now)

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
        submitted_job_offer = create(:job_offer, state: 'submitted', submitted_at: Time.zone.now)
        unsubmitted_job_offer = create(:job_offer, state: 'created', submitted_at: nil)

        get :index 

        expect(assigns(:job_offers).pluck(:id)).to eq [submitted_job_offer.id]
      end
      it 'assigns job offers ordered by submission date and publication date' do
        new_published_job = create(:job_offer, state: 'published', submitted_at: Time.zone.now, published_at: Time.zone.now)
        old_published_job = create(:job_offer, state: 'published', submitted_at: Time.zone.now - 1.day, published_at: Time.zone.now - 1.day)
        older_submitted_job = create(:job_offer, state: 'submitted', submitted_at: Time.zone.now - 2.day, published_at: nil)
        oldest_submitted_job = create(:job_offer, state: 'submitted', submitted_at: Time.zone.now - 3.day, published_at: nil)

        get :index

        expect(assigns(:job_offers).pluck(:id)).to eq [ older_submitted_job, oldest_submitted_job, new_published_job, old_published_job ].map(&:id) end
    end
  end

  describe 'POST #create' do
    it 'creates new JobOffer record' do
      post :create, params: {job_offer: attributes_for(:job_offer, title: 'Senior Ruby on Rails Developer').merge({company_attributes: attributes_for(:company)})}

      expect(JobOffer.last.title).to eq 'Senior Ruby on Rails Developer'
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

  describe 'PATCH #update' do
    it 'updates existing JobOffer record' do
      job_offer = create(:job_offer, title: 'RoR Developer')

      patch :update, params: {token: job_offer.token, job_offer: {title: 'Junior RoR Developer'}}

      expect(job_offer.reload.title).to eq 'Junior RoR Developer'
    end

    it 'redirects to preview page' do
      job_offer = create(:job_offer, title: 'RoR Developer')

      patch :update, params: {token: job_offer.token, job_offer: {title: 'Junior RoR Developer'}}

      expect(response).to redirect_to(job_offers_preview_path(job_offer.token))
    end

    context 'when invalid job offer params' do
      it 'rerenders #edit view' do
        job_offer = create(:job_offer, title: 'RoR Developer')

        patch :update, params: {token: job_offer.token, job_offer: {title: ''}}

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #show' do
    before :each do 
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do 
      ActiveJob::Base.queue_adapter = :inline
    end

    context 'when job_offer is published' do
      it 'enqueues RegisterJobOfferVisitJob' do
        job_offer = create(:job_offer, state: 'published', published_at: Time.zone.now)

        expect { get :show, params: {id: job_offer.id} }.to have_enqueued_job(RegisterJobOfferVisitJob).with(job_offer.id)
      end
    end

    context 'when job_offer is not published' do
      it 'does not enqueue RegisterJobOfferVisitJob' do
        job_offer = create(:job_offer, published_at: nil)

        expect { get :show, params: {id: job_offer.id} }.to_not have_enqueued_job(RegisterJobOfferVisitJob).with(job_offer.id)
      end
    end

    context 'when job_offer is closed' do
      it 'sets flash message' do
        job_offer = create(:job_offer, state: 'closed')

        get :show, params: {id: job_offer.id}

        expect(flash[:notice]).to eq 'Ogłoszenie jest już nieaktualne.'
      end
    end
  end
end
