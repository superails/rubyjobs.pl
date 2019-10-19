require 'rails_helper'

RSpec.describe JobOffers::RedirectsController, type: :controller do
  describe 'GET #show' do
    before :each do 
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do 
      ActiveJob::Base.queue_adapter = :inline
    end

    context 'when job_offer is published' do
      it 'enqueues RegisterApplyLinkClickJob' do
        job_offer = create(:job_offer, published_at: Time.zone.now, apply_link: 'https://rubyjobs.pl/careers/ruby-developer')

        expect { get :show, params: {id: job_offer.id} }.to have_enqueued_job(RegisterApplyLinkClickJob).with(job_offer.id)
      end
    end

    context 'when job_offer is not published' do
      it 'does not enqueue RegisterJobOfferVisitJob' do
        job_offer = create(:job_offer, published_at: nil, apply_link: 'https://rubyjobs.pl/careers/ruby-developer')

        expect { get :show, params: {id: job_offer.id} }.to_not have_enqueued_job(RegisterApplyLinkClickJob).with(job_offer.id)
      end
    end

  end
end

