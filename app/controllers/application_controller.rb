class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  rescue_from ActiveRecord::RecordNotFound, with: :content_not_found
  rescue_from ActionController::RoutingError, with: :content_not_found
  helper_method :current_user
  helper_method :logged_in?
  helper_method :login_required
  helper_method :administrator_required
  helper_method :individual_required

  def logged_in?
    session[:user_id]
  end

  def login_required
    unless logged_in?
      redirect_to login_path
    end
  end

  def administrator_required
    user_type_required("Administrator")
  end

  def individual_required
    user_type_required("Individual")
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_type_required(type)
    if logged_in?
      @current_user = current_user
      unless @current_user.role == type
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def content_not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end
