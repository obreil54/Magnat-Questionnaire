class User < ApplicationRecord
  attr_accessor :remember_token

  before_create :generate_code
  has_many :hardwares
  has_many :responses, dependent: :destroy
  before_destroy :update_hardwares_status

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, format: { with: /\A[a-zA-Z'’\-\s]+\z/, message: "only allows letters, hyphens, apostrophes, and spaces" }

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
    self.code = SecureRandom.random_number(10000).to_s.rjust(4, '0')
  end

  def send_login_code
    UserMailer.with(user: self).login_code_email.deliver_later
  end

  def admin?
    admin
  end

  private

  def update_hardwares_status
    hardwares.update_all(status: false, loaned_at: nil, user_id: nil)
  end
end
