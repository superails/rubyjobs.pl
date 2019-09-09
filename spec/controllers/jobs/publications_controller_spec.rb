
require 'rails_helper'

RSpec.describe Jobs::PublicationsController, type: :controller do
  describe 'POST #create' do
    it 'destroys current job_id in session' do
      job = create(:job)
      session[:job_id] = job.id

      post :create

      expect(session[:job_id]).to be_nil
    end
  end

end
