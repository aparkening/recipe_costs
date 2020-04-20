class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user
  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :set_user, only: [:index, :new, :create]

  # Display all users if admin
  def index
    if is_admin?
      @users = User.all.order(name: :asc)
      @user = current_user
    else
      return head(:forbidden)
      # redirect_to root_path, error: "You're not authorized to see this resource."
    end
  end

  # Display new form
  def new
    @user = User.new
  end
  
  # Create record
  def create
    # Set correct admin data if box checked
    params[:user][:admin] = "true" if params[:user][:admin] && params[:user][:admin] == "1"

    # Create user
    @user = User.new(user_params)

    # Set session and redirect unless admin or error
    if @user.save
      if is_admin?
        flash[:success] = "Success! #{@user.name} created."
        redirect_to users_path
      else 
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      end
    else
      render :new
    end
  end

  # Display record
  def show
    redirect_non_users
    require_authorization(@user)

    # Get all ingredients used by user
    @ingredients = @user.recipes.all_ingredients
  end  

  # Display edit form
  def edit
    redirect_non_users

    require_authorization(@user)
  end
 
  # Update record
  def update
    redirect_non_users
    require_authorization(@user)

    # Set correct admin data if box checked
    params[:user][:admin] = "true" if params[:user][:admin] && params[:user][:admin] == "1"

    # Update record
    @user.update(user_params)

    # Redirect unless error
    if @user.save
      if @user == current_user
        redirect_to @user, notice: "Success! You're updated."
      else 
        redirect_to users_path, notice: "#{@user.name} successfully updated."
      end
    else
      render :edit
    end
  end

  # Delete record
  def destroy
    # Only admins can delete users
    if is_admin?
      # Destroy unless error
      if @user
        flash[:success] = "Success! #{@user.name.titleize} deleted."
        user.destroy
      else
        flash[:alert] = "Custom cost not found."
      end

      redirect_to users_path
    else
      redirect_to root_path, error: "You're not authorized to change this resource."
    end
  end

  private
 
  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :organization, :email, :admin)
  end
  
end