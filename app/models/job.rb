class Job < ApplicationRecord
  belongs_to :company

  accepts_nested_attributes_for :company

  attr_accessor :location, :remote
end
