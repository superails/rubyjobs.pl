class JobOffers::SubmissionsController < ApplicationController
  def create
    job_offer = JobOffer.find(session[:job_offer_id])

    session.delete(:job_offer_id)

    if current_user.admin?
      JobOfferSubmitter.new(job_offer, with_email: false).call
      JobOfferPublisher.new(job_offer).call
      flash[:notice] = "Ogłoszenie zostało opublikowane."
    else
      JobOfferSubmitter.new(job_offer).call
      flash[:notice] = "Ogłoszenie czeka na akceptację. Po akceptacji otrzymasz maila na adres #{job_offer.email}"
    end

    redirect_to root_path
  end

  def destroy
    @job_offer = JobOffer.find(params[:job_offer_id])
    authorize @job_offer

    @job_offer.update(submitted_at: nil)
    redirect_back(fallback_location: root_path)
  end
end

