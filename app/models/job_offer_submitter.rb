class JobOfferSubmitter
  attr_reader :job_offer

  def initialize(job_offer)
    @job_offer = job_offer
  end

  def call
    job_offer.update(submitted_at: Time.zone.now)

    JobOfferMailer.with(id: job_offer.id).submit.deliver_later
  end
end