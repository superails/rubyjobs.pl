class JobOfferExpirationChecker
  def call
    JobOffer.published.
      where('published_at < ?', Time.zone.now - JobOffer::DEFAULT_EXPIRATION_TIME).
      each(&:expire!)
  end
end
