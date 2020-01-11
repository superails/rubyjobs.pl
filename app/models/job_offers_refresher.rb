class JobOffersRefresher
  def self.call
    JobOffer.published.
      where('published_at < ?', Time.zone.now - JobOffer::DEFAULT_REFRESH_TIME).
      each(&:refresh!)
  end
end
