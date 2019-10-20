class JobOffers::RedirectsController < ApplicationController
  def show
    @job_offer = JobOffer.find(params[:id])

    RegisterApplyLinkClickJob.perform_later(@job_offer.id) if @job_offer.published?

    if @job_offer.apply_link =~ URI::MailTo::EMAIL_REGEXP
      redirect_to "mailto:#{@job_offer.apply_link}"
    else
      redirect_to @job_offer.apply_link
    end
  end
end
