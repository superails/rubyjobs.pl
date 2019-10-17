class JobOfferPublisher
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    job_offer.update(published_at: Time.zone.now)

    JobOfferMailer.with(id: job_offer.id).publish.deliver_later
  end
end
