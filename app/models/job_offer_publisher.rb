class JobOfferPublisher
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    current_time = Time.zone.now

    job_offer.update(published_at: current_time,
                     visits_count: 0,
                     apply_link_clicks_count: 0,
                     submitted_at: job_offer.submitted_at ? job_offer.submitted_at : current_time)

    JobOfferMailer.with(id: job_offer.id).publish.deliver_later
  end
end
