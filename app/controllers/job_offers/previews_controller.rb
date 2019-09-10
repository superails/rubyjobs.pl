class JobOffers::PreviewsController < ApplicationController
  def show
    @job_offer = JobOffer.find(session[:job_offer_id]).decorate
  end
end

