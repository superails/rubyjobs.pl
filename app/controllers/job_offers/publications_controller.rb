class JobOffers::PublicationsController < ApplicationController
  before_action :find_job_offer
  before_action :authorize_job_offer

  def create
    @job_offer.update(published_at: Time.zone.now)

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @job_offer.update(submitted_at: nil)

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

