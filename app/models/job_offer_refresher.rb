class JobOfferRefresher
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    current_published_at = @job_offer.published_at
    current_visits_count = @job_offer.visits_count
    current_apply_link_clicks_count = @job_offer.apply_link_clicks_count

    @job_offer.update(published_at: Time.zone.now, visits_count: 0, apply_link_clicks_count: 0)

    JobOfferMailer.with(
      id: job_offer.id,
      previous_published_at: current_published_at.strftime("%d-%m-%Y %H:%M"),
      visits_count: current_visits_count,
      apply_link_clicks_count: current_apply_link_clicks_count
    ).refresh.deliver_later
  end
end
