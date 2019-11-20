class JobOfferExpirationChecker
  def call
    JobOffer.
      where(state: 'published').
      where('published_at < ?', Time.zone.now - JobOffer::DEFAULT_EXPIRATION_TIME).
      each(&:expire!)
  end
end
