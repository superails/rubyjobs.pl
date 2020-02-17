namespace :facets do
  desc "Generates facets for each job offer"
  task generate: :environment do
    JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call } 
  end
end

