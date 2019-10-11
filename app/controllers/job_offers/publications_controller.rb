class JobOffers::PublicationsController < ApplicationController
  before_action :find_job_offer
  before_action :authorize_job_offer

  def create
    JobOfferPublisher.new(@job_offer).call

    redirect_back(fallback_location: root_path)
  end

  private

  def find_job_offer
    @job_offer = JobOffer.find(params[:job_offer_id])
  end

  def authorize_job_offer
    authorize @job_offer
  end
end

