class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Display root page. If current user, show user page.
  def index
    redirect_to @current_user if current_user
  end

  # Set ingredient units. Too many extraneous units in Measured; manual list easier.
  def available_units
    # After manual set, duplicate map for form select lists
    all_units = ['gram', 'kg', 'lb', 'oz', 'liter', 'gal', 'qt', 'pt', 'us_fl_oz', 'tsp', 'tbsp', 'cup', 'each'].map { |unit| [unit, unit] }.sort
    return all_units
	end

  # Return current user. Set current user if doesn't already exist and user id present.
	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
	end
  helper_method :current_user
  
  # Return true if current user exists and is admin
  def is_admin?
    current_user && current_user.admin
  end
  helper_method :is_admin?

  # Return true if user is the current user or admin
  def user_authorized?(user)
    user == current_user || is_admin?
  end

  # Return true if user authorized. Else redirect and return false.
  def authorize(user="no")
    # if user.nil?
    #   not_authorized("User not found.")
    #   false
    if user == 'no'
      require_login
      !!current_user
    else
      if user_authorized?(user)
        true
      else
        not_authorized
        false
      end
    end
  end

  private

  # Redirect with flash error 
  def not_authorized(msg = "Access Denied. You don't have access to this resource.")
    flash[:error] = msg
    redirect_to root_path
  end

  # Check database for user provided by params. Redirect if none found.
  def redirect_non_users(id = params[:user_id])
    not_authorized("User not found.") if id && !User.exists?(id)
  end

  # Redirect if not logged in
  def require_login
    not_authorized("Please sign up or log in above to access this resource.") unless current_user
  end
  helper_method :require_login

  # Redirect if user not admin
  def require_admin
    not_authorized("Invalid credentials.") unless is_admin?
  end

end