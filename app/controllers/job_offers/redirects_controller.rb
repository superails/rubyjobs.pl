class JobOffers::RedirectsController < ApplicationController
  def show
    @job_offer = JobOffer.find(params[:id])

    RegisterApplyLinkClickJob.perform_later(@job_offer.id)

    redirect_to @job_offer.apply_link
  end
end
