class User < ApplicationRecord
  attr_accessor :remember_token

  before_create :status_change
  before_validation :sanitize_email_address
  has_many :hardwares
  has_many :responses, dependent: :destroy
  has_secure_password validations: false

  validates :name, :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { should_validate_password? }
  validates :code, uniqueness: true

  class << self; attr_accessor :codes_imported; end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def generate_code
    self.log_in_code = SecureRandom.random_number(10000).to_s.rjust(4, '0')
  end

  def send_login_code
    UserMailer.with(user: self).login_code_email.deliver_later
  end

  def admin?
    admin
  end

  def self.before_import
    self.codes_imported = []
  end

  def after_import_save(record)
    self.class.codes_imported << record[:code] if record[:code].present?
  end

  def self.after_import
    User.where.not(code: self.codes_imported).where(admin: false).update_all(status: false, updated_at: Time.current)
  end

  def sanitize_email_address
    self.email = email.gsub(/^mailto:/, '') if email.present?
  end

  private

  def should_validate_password?
    admin? && (password.present? || password_digest.blank?)
  end

  def update_password_if_present
    self.password = password.presence
  end
end
