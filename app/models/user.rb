class User < ApplicationRecord
  before_create :generate_code
  has_many :hardwares
  has_many :responses, dependent: :destroy
  before_destroy :update_hardwares_status

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, format: { with: /\A[a-zA-Z'’\-\s]+\z/, message: "only allows letters, hyphens, apostrophes, and spaces" }



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
