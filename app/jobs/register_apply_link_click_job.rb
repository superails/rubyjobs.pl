class RegisterApplyLinkClickJob < ApplicationJob
  queue_as :default

  def perform(id)
    JobOffer.increment_counter(:apply_link_clicks_count, id)
  end
end
