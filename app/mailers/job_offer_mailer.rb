class JobOfferMailer < ApplicationMailer
  def summary
    job_offer = JobOffer.find(params[:id])

    mail(to: job_offer.email, subject: "Twoje ogłoszenie na rubyjobs.pl zostało dodane")
  end

  def expired
    job_offer = JobOffer.find(params[:id])

    mail(to: job_offer.email, subject: "Twoje ogłoszenie na rubyjobs.pl wygasło")
  end
end
