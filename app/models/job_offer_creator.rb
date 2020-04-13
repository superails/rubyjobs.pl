class JobOfferCreator
  attr_reader :job_offer_params

  def initialize(job_offer_params)
    @job_offer_params = job_offer_params
  end

  def call
    job_offer = JobOffer.create(job_offer_params)
    job_offer
  end
end
