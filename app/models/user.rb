class User < ApplicationRecord
  before_create :generate_code
  has_many :it_equipments
  has_many :answers

  def generate_code
    self.code = SecureRandom.random_number(10000).to_s.rjust(4, '0')
  end

  def send_login_code
    UserMailer.with(user: self).login_code_email.deliver_later
  end
end
