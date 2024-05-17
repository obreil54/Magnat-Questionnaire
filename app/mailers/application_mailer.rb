class ApplicationMailer < ActionMailer::Base
  default from: -> { system_email_address }
  layout "mailer"

  private

  def system_email_address
    Setting.email_system_name
  end
end
