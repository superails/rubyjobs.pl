class JobOfferExpirationChecker
  def call
    expired_job_offers = JobOffer.
      where.not(published_at: nil).
      where('published_at < ?', Time.zone.now - JobOffer::DEFAULT_EXPIRATION_TIME).
      where(expired_at: nil)

    expired_job_offers.each do |expired_job_offer|
      expired_job_offer.update(expired_at: Time.zone.now)
      JobOfferMailer.with(id: expired_job_offer.id).expire.deliver_now
    end
  end
end
