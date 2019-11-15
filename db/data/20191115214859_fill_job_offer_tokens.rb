class FillJobOfferTokens < ActiveRecord::Migration[5.2]
  def up
    JobOffer.all.each {|job_offer| job_offer.generate_token; job_offer.save}
  end

  def down
    JobOffer.update_all(token: nil)
  end
end
