class JobOfferSubmitter
  attr_reader :job_offer, :with_email

  def initialize(job_offer, with_email: true)
    @job_offer = job_offer
    @with_email = with_email
  end

  def call
    job_offer.update(submitted_at: Time.zone.now)

    JobOfferMailer.with(id: job_offer.id).submit.deliver_later if with_email
  end
end
