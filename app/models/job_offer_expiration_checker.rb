class JobOfferExpirationChecker
  def call
    expired_job_offers = JobOffer.
      where('published_at < ?', Time.zone.now - JobOffer::DEFAULT_EXPIRATION_TIME).
      where(expired_at: nil)

    expired_job_offers.each do |expired_job_offer|
      JobOfferMailer.with(id: expired_job_offer.id).expired.deliver_now
    end

    expired_job_offers.update_all(expired_at: Time.zone.now)
  end
end
