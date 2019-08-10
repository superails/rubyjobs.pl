class Company < ApplicationRecord
  has_many :jobs

  has_one_attached :logo
end
