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
end
