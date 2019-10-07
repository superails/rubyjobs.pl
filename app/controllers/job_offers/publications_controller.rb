class JobOffers::PublicationsController < ApplicationController

  def create
    job_offer = JobOffer.find(params[:job_offer_id])
    authorize job_offer
    job_offer.update(published_at: Time.zone.now)

    redirect_back(fallback_location: root_path)
  end

  def destroy
    job_offer = JobOffer.find(params[:job_offer_id])
    job_offer.update(submitted_at: nil)

    redirect_back(fallback_location: root_path)
  end
end

