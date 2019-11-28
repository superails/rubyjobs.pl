class JobOffer < ApplicationRecord
  include AASM

  DEFAULT_EXPIRATION_TIME = 30.days

  belongs_to :company
  has_many :sites, dependent: :destroy 
  has_many :locations, through: :sites

  scope :active, -> { where("state != 'expired' AND state != 'created'") }

  has_one_attached :logo

  accepts_nested_attributes_for :company

  validates :title, :locations, :salary, :apply_link, :email, presence: true
  validate :emails_have_correct_format

  before_create :generate_token

  aasm column: 'state' do
    state :created, initial: true
    state :submitted
    state :published
    state :expired

    event :submit do
      transitions from: [:created, :expired], to: :submitted, success: -> { JobOfferSubmitter.new(self).call }
    end

    event :publish  do
      transitions from: [:created, :submitted, :expired], to: :published, success: -> { JobOfferPublisher.new(self).call } 
    end

    event :expire do
      transitions from: :published, to: :expired, success: -> { JobOfferExpirer.new(self).call }
    end

    event :reject do
      transitions from: :submitted, to: :created, success: -> { update(submitted_at: nil) } 
    end
  end

  def city_names
    locations.reject{|location| location.name == 'Zdalnie'}.map(&:name).join(', ')
  end

  def city_names=(city_names)
    location_params = city_names.split(/\s*,\s*/).map do |city_name|
      {name: city_name}
    end

    self.locations = (
      locations + location_params.map{|location_params| Location.find_or_initialize_by(location_params)}
    ).uniq(&:name)
  end

  def emails
    email.to_s.split(',').map(&:strip)
  end

  def remote
    locations.select{|location| location.name == 'Zdalnie'}.count > 0 ? '1' : '0'
  end

  def remote=(value)
    if value == "1"
      locations << Location.find_or_initialize_by(name: 'Zdalnie') if value == "1"
    elsif value == "0" && remote_location = Location.find_by(name: 'Zdalnie')
      locations.destroy(remote_location)
    end
  end

  def company_attributes=(attributes)
    self.company = Company.find_or_initialize_by(name: attributes[:name]) do |company|
      company.logo = attributes[:logo]
    end
  end

  def to_param
    [id, title.parameterize, company.name.parameterize].join('-')
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless JobOffer.exists?(token: random_token)
    end
  end

  def expiration_time_in_days
    duration_parts = ActiveSupport::Duration.build(DEFAULT_EXPIRATION_TIME).parts
    duration_parts[:weeks].to_i * 7 + duration_parts[:days]
  end

  def logo_attached?
    logo.attached? || company.logo.attached?
  end

  private

  def emails_have_correct_format
    errors.add(:email, I18n.t('errors.messages.invalid')) if emails.any?{ |email| email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  end
end
