class JobOffer < ApplicationRecord
  DEFAULT_EXPIRATION_TIME = 30.days

  belongs_to :company
  has_many :sites
  has_many :locations, through: :sites

  has_one_attached :logo

  accepts_nested_attributes_for :company

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
  scope :submitted, -> { where.not(submitted_at: nil) }
  scope :active, -> { where(expired_at: nil) }

  validates :title, :locations, :salary, :apply_link, :email, presence: true
  validate :emails_have_correct_format

  before_create :generate_token

  def city_names
    locations.reject{|location| location.name == 'Zdalnie'}.map(&:name).join(', ')
  end

  def city_names=(city_names)
    location_params = city_names.split(/\s*,\s*/).map do |city_name|
      {name: city_name}
    end

    locations << location_params.map{|location_params| Location.find_or_initialize_by(location_params)}
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

  def expiration_time
    (created_at + DEFAULT_EXPIRATION_TIME).strftime("%d.%m.%Y")
  end

  def published?
    !!published_at
  end

  def unpublished?
    !published_at
  end

  def submitted?
    !!submitted_at
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

  private

  def emails_have_correct_format
    errors.add(:email, I18n.t('errors.messages.invalid')) if emails.any?{ |email| email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  end
end
