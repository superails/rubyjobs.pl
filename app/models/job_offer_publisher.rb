class JobOfferPublisher
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    current_time = Time.zone.now

    if job_offer.submitted_at
      job_offer.update(published_at: current_time)
    else
      job_offer.update(published_at: current_time, submitted_at: current_time)
    end

    JobOfferMailer.with(id: job_offer.id).publish.deliver_later
  end
end
