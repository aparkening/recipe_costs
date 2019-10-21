class UsersController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  # Display all users
  def index
    if is_admin?
      @users = User.all.order(name: :asc)
      @user = current_user
    else
      return head(:forbidden)
      # redirect_to root_path, error: "You're not authorized to see this resource."
    end
  end

  # Display user page
  def show
    redirect_non_users
    @user = User.find(params[:id])
    require_authorization(@user)

    # Get all ingredients used by user
    @ingredients = @user.recipes.all_ingredients
  end

  # Display signup form
  def new
    @user = User.new
  end
  
  # Create user
  def create
    # Set correct admin data if box checked
    params[:user][:admin] = "true" if params[:user][:admin] && params[:user][:admin] == "1"

    @user = User.new(user_params)
    if @user.save
      # Set session if current user isn't an admin
      if is_admin?
        redirect_to users_path, notice: "#{@user.name} successfully created."
      else 
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      end
    else
      # flash[:error] = @user.errors.full_messages
      # redirect_to new_user_path
      render :new
    end
  end

  # Display edit form
  def edit
    redirect_non_users
    @user = User.find(params[:id])

    # Require authorization
    require_authorization(@user)
  end
 
  # Update user
  def update
    redirect_non_users
    @user = User.find(params[:id])

    # Require authorization
    require_authorization(@user)

    # Set correct admin data if box checked
    params[:user][:admin] = "true" if params[:user][:admin] && params[:user][:admin] == "1"

    @user.update(user_params)

    if @user.save
      # Set session if current user isn't an admin
      if @user == current_user
        redirect_to @user, notice: "Success! You're updated."
      else 
        redirect_to users_path, notice: "#{@user.name} successfully updated."
      end
    else
      # flash[:error] = @user.errors.full_messages
      # flash[:error] = "Credentials don't work. Please ensure your passwords match."
      render :edit
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
    params.require(:user).permit(:name, :password, :password_confirmation, :organization, :email, :admin)
  end
  
end