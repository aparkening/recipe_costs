class UsersController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  # Display user page
  def show
    @user = User.find(params[:id])
  end

  # Display signup form
  def new
    @user = User.new
  end
  
  # Create user
  def create
    # params[:user][:admin] = "true" if params[:user][:role] && params[:user][:role] == "admin"

    @user = User.new(user_params)
    if @user.save
      # Set session if current user isn't an admin
      session[:user_id] = @user.id if !is_admin?
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages
      # flash[:error] = "Credentials don't work" 
      # redirect_to new_user_path, error: "Credentials don't work. Please ensure your passwords match."
      redirect_to new_user_path
    end
  end
 
  private
 
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :organization, :role)
  end
  
end