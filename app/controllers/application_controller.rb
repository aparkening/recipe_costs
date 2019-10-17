class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Display root page. If current user, show user page.
  def index
    redirect_to @current_user if current_user
  end

  # Set current user
	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
	end
  helper_method :current_user
  
  # Determine if current user is admin
  def is_admin?
    @current_user && @current_user.role == "admin"
  end
  helper_method :is_admin?

  private
	 
  def require_login
    redirect_to root_path unless current_user
  end

end