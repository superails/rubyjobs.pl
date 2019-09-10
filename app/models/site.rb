class Site < ApplicationRecord
  belongs_to :job_offer
  belongs_to :location
end
