class Company < ApplicationRecord
  has_many :job_offers

  has_one_attached :logo
end
