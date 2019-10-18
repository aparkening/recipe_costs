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
    current_user && current_user.admin
  end
  helper_method :is_admin?

  # Raise errors if user doesn't have permissions to access
  def user_authorized?(user)
    user == current_user || is_admin?
  end

  # Raise error if user not authorized
  def require_authorization(user)
    return head(:forbidden) unless current_user == user || is_admin? 
  end 
  helper_method :require_authorization

  private
	 
  def require_login
    return head(:forbidden) unless current_user
  end

end