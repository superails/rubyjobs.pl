class BuildFacets < ActiveRecord::Migration[5.2]
  def up
    JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call}
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
