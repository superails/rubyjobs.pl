class JobOffers::PublicationsController < ApplicationController
  def create
    job_offer = JobOffer.find(session[:job_offer_id])

    JobOfferPublisher.new(job_offer).call

    session.delete(:job_offer_id)

    flash[:notice] = "Ogłoszenie zostało opublikowane, informacje zostały wysłane na adres #{job_offer.email}"
    redirect_to root_path
  end
end

