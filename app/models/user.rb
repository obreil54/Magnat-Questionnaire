class User < ApplicationRecord
  before_create :generate_code
  has_many :it_equipments
  has_many :answers, dependent: :destroy
  before_destroy :update_it_equipments_status

  validates :first_name, :last_name, :email, :status, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z'’\-\s]+\z/, message: "only allows letters, hyphens, apostrophes, and spaces" }



  def generate_code
    self.code = SecureRandom.random_number(10000).to_s.rjust(4, '0')
  end

  def send_login_code
    UserMailer.with(user: self).login_code_email.deliver_later
  end

  private

  def update_it_equipments_status
    it_equipments.update_all(status: false, loaned_at: nil, user_id: nil)
  end
end
