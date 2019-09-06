require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe 'GET #index' do
    it 'assigns only published jobs to @jobs' do
      published_job = create(:job, published_at: Time.zone.now)
      unpublished_job = create(:job, published_at: nil)

      get :index 

      expect(assigns(:jobs).pluck(:id)).to eq [published_job.id]
    end
  end

  describe 'GET #new' do
    context 'when job_id saved in session' do
      it 'assigns copy of Job with job_id from session to @job' do
        current_job = create(:job, 
                             title: 'Senior Ruby on Rails developer',
                             location: "Warszawa, Białystok",
                             remote: '1')
        session[:job_id] = current_job.id

        get :new

        expect(assigns(:job).title).to eq 'Senior Ruby on Rails developer'
        expect(assigns(:job).location).to eq 'Warszawa, Białystok'
        expect(assigns(:job).company.name).to eq current_job.company.name
        expect(assigns(:job).remote).to eq '1'
      end
    end
  end

  describe 'POST #create' do
    context 'when job_id saved in session' do
      it 'destroys Job with id saved in session' do
        current_job = create(:job)
        session[:job_id] = current_job.id

        post :create, params: {job: attributes_for(:job).merge({company_attributes: attributes_for(:company)})}

        expect(session[:job_id]).to_not eq current_job.id
      end
    end

    it 'creates new Job record' do
      post :create, params: {job: attributes_for(:job, title: 'Senior Ruby on Rails Developer').merge({company_attributes: attributes_for(:company)})}

      expect(Job.last.title).to eq 'Senior Ruby on Rails Developer'
    end

    it 'saves new Job record\'s id in session' do
      post :create, params: {job: attributes_for(:job, title: 'Senior Ruby on Rails Developer').merge({company_attributes: attributes_for(:company)})}

      expect(session[:job_id]).to eq Job.last.id
    end
  end
end
