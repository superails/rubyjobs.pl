class JobOfferMailer < ApplicationMailer
  before_action :find_job_offer

  def submit
    mail(to: @job_offer.email, subject: "Twoje ogłoszenie zostało dodane i czeka na publikację")
  end

  def publish
    mail(to: @job_offer.email, subject: "Twoje ogłoszenie zostało opublikowane")
  end

  def expire
    mail(to: @job_offer.email, subject: "Twoje ogłoszenie przestało być wyświetlane")
  end

  private

  def find_job_offer
    @job_offer = JobOffer.find(params[:id])
  end
end
