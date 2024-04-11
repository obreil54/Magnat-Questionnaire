class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user.nil?
      redirect_to login_path, alert: "Пользователь с email #{params[:session][:email]} не зарегистрирован в системе!"
    elsif @user.status == false
      redirect_to login_path, alert: "Для пользователя с email #{@user.email} доступ закрыт."
    else
      session[:verification_email] = @user.email
      if @user.admin?
        redirect_to admin_password_path
      else
        handle_non_admin_login(@user)
      end
    end
  end

  def verify
  end

  def verify_code
    email = session[:verification_email]
    code = params[:verification][:log_in_code]
    remember_me = params[:verification][:remember_me] == "1"
    @user = User.find_by(email: email, log_in_code: code)
    if @user
      log_in(@user)
      remember(@user) if remember_me
      redirect_to user_profile_path
    else
      redirect_to verify_path, alert: "Неверный код."
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def check_remember_me
    if cookies.signed[:user_id] && session[:verification_email]
      user = User.find_by(id: cookies.signed[:user_id])
      user && user.email == session[:verification_email] && user.authenticated?(cookies[:remember_token])
    end
  end

  def redirect_if_logged_in
    if check_remember_me
      log_in(User.find_by(id: cookies.signed[:user_id]))
      redirect_to user_profile_path and return
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def new_admin_password
    if check_remember_me
      user = User.find_by(email: session[:verification_email])
      log_in(user)
      redirect_to rails_admin_path
    end
  end

  def verify_admin_password
    user = User.find_by(email: session[:verification_email])
    if user && user.authenticate(params[:session][:password])
      remember(user) if params[:session][:remember_me] == "1"
      handle_admin_login(user)
    else
      redirect_to admin_password_path, alert: "Неверный пароль."
    end
  end

  def handle_admin_login(user)
    log_in(user)
    redirect_to rails_admin_path
  end

  private

  def handle_non_admin_login(user)
    if check_remember_me
      log_in(user)
      redirect_to user_profile_path
    else
      session[:remember_me] = params[:session][:remember_me]
      user.generate_code
      user.save
      user.send_login_code
      redirect_to verify_path, notice: "Код был отправлен на #{user.email}."
    end
  end
end
