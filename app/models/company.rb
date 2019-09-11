class Company < ApplicationRecord
  has_many :job_offers

  has_one_attached :logo
  validates :name, presence: true
end
