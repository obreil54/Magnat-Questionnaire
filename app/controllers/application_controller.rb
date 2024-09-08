class ApplicationController < ActionController::Base
  before_action :set_cache_headers
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def authenticate_user
    redirect_to root_path, alert: "Вы должны войти в систему, чтобы получить доступ к этой странице." unless session[:user_id]
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end
end
