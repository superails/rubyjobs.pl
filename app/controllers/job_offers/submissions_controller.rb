class JobOffers::SubmissionsController < ApplicationController
  def create
    job_offer = JobOffer.find_by(token: params[:token])

    if current_user.admin?
      job_offer.publish!

      flash[:notice] = "Ogłoszenie zostało opublikowane."
    else
      job_offer.submit!

      flash[:notice] = "Ogłoszenie czeka na akceptację. Po akceptacji otrzymasz maila na adres #{job_offer.email}"
    end

    redirect_to root_path
  end

  def destroy
    @job_offer = JobOffer.find_by(token: params[:token])
    authorize @job_offer

    @job_offer.reject!
    redirect_back(fallback_location: root_path)
  end
end

