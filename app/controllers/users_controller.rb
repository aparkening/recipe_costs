class UsersController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  # Display user page
  def show
    @user = User.find(params[:id])
    redirect_to root_path if current_user != @user || !is_admin?
  end

  # Display signup form
  def new
    @user = User.new
  end

  # Display edit form
  def edit
    @user = User.find(params[:id])
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
      # flash[:error] = @user.errors.full_messages
      redirect_to new_user_path, error: "Credentials don't work. Please ensure your passwords match."
    end
  end
 
  # Edit user
  def update
    @user = User.find(params[:id])

    # Ensure edits are made by owner or admin user
    if user_authorized?(@user)
      @user.update(user_params)
      if @user.save
        redirect_to @user
      else
        render :edit
      end
    else
      redirect_to root_path, error: "You're not authorized to change this resource."
    end
  end

  # Delete user
  def destroy
    # Ensure only admins can delete users
    if is_admin?
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User deleted"
      redirect_to users_path
    else
      redirect_to root_path, error: "You're not authorized to change this resource."
    end
  end


  private
 
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :organization, :role)
  end
  
end