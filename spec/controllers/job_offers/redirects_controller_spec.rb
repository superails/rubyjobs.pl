require 'rails_helper'

RSpec.describe JobOffers::RedirectsController, type: :controller do
  before :each do 
    ActiveJob::Base.queue_adapter = :test
  end

  after :each do 
    ActiveJob::Base.queue_adapter = :inline
  end

  describe 'GET #show' do
    it 'enqueues RegisterApplyLinkClickJob' do
      job_offer = create(:job_offer, apply_link: 'https://rubyjobs.pl/careers/ruby-developer')

      expect { get :show, params: {id: job_offer.id} }.to have_enqueued_job(RegisterApplyLinkClickJob).with(job_offer.id)
    end
  end
end

