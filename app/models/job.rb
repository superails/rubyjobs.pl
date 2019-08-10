class Job < ApplicationRecord
  belongs_to :company
  has_many :sites
  has_many :locations, through: :sites

  accepts_nested_attributes_for :company

  attr_accessor :location, :remote
end
