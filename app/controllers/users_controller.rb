class UsersController < ApplicationController
  before_action :require_login
  def show
    @user = current_user
    @hardware = current_user.hardwares
    @questionnaire = Questionnaire.find_by(status: true)
  end

  private

  def require_login
    redirect_to root_path, alert: "Вы должны войти в систему, чтобы получить доступ к этой странице." unless session[:user_id]
  end
end
