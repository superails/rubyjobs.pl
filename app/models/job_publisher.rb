class JobPublisher
  attr_reader :job

  def initialize(job)
    @job = job
  end

  def call
    job.update(published_at: Time.zone.now)

    JobMailer.with(id: job.id).summary.deliver_now
  end
end
