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
      redirect_to verify_path, notice: "A code has been sent to your email."
    else
      redirect_to login_path, alert: "No such email in the database."
    end
  end

  def verify
  end

  def verify_code
    email = session[:verification_email]
    code = params[:verification][:code]
    p "Email: #{email}, Code: #{code}"
    @user = User.find_by(email: email, code: code)
    if @user
      session[:user_id] = @user.id
      redirect_to root_path, notice: "You are now logged in."
    else
      redirect_to verify_path, alert: "Invalid code."
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "You are now logged out."
  end
end
