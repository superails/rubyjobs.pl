class RegisterJobOfferVisitJob < ApplicationJob
  queue_as :default

  def perform(id)
    JobOffer.increment_counter(:visits_count, id)
  end
end
