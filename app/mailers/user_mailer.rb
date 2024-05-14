class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.login_code_email.subject
  #
  def login_code_email
    @user = params[:user]
    @code = @user.log_in_code
    mail(to: @user.email, subject: "it-audit. Код подтверждения для входа")
  end
end
