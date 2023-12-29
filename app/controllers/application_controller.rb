class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  #before_action :login_required

  def logged_in?
    session[:user_id]
  end

  def login_required
    unless logged_in?
      redirect to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
