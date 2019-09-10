class JobOffers::SummariesController < ApplicationController
  def show
    @job_offer = JobOffer.find(session[:job_offer_id]).decorate
  end
end

