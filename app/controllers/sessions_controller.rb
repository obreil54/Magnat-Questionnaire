class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user
      session[:verification_email] = @user.email
      @user.generate_code
      @user.save
      @user.send_login_code
      redirect_to verify_path, notice: "Код был отправлен на вашу электронную почту"
    else
      redirect_to login_path, alert: "В базе данных нет такого адреса электронной почты."
    end
  end

  def verify
  end

  def verify_code
    email = session[:verification_email]
    code = params[:verification][:code]
    @user = User.find_by(email: email, code: code)
    if @user
      session[:user_id] = @user.id
      redirect_to user_profile_path
    else
      redirect_to verify_path, alert: "Неверный код."
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
