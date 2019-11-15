class JobOffers::PreviewsController < ApplicationController
  def show
    @job_offer = JobOffer.find_by(token: params[:token]).decorate
  end
end

