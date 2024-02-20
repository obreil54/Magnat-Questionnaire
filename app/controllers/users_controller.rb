class UsersController < ApplicationController
  before_action :require_login
  def show
    @user = current_user
    @equipment = current_user.it_equipments
    @questionnaires = @equipment.flat_map(&:questionnaires)
  end

  private

  def require_login
    redirect_to root_path, alert: "You must be loggen in to access this page." unless session[:user_id]
  end
end
