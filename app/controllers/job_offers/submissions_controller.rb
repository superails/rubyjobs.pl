class JobOffers::SubmissionsController < ApplicationController
  def create
    job_offer = JobOffer.find(session[:job_offer_id])

    session.delete(:job_offer_id)

    job_offer.update(submitted_at: Time.zone.now)

    flash[:notice] = "Ogłoszenie czeka na akceptację. Po akceptacji otrzymasz maila na adres #{job_offer.email}"
    redirect_to root_path
  end
end

