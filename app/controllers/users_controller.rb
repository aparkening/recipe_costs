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
    params[:user][:admin] = "true" if params[:user][:admin] && params[:user][:admin] == "1"

    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:error] = "Credentials don't work" 
      redirect_to new_user_path
    end
  end
 
  private
 
  def user_params
    params.require(:user).permit(:name, :password, :height, :happiness, :nausea, :tickets, :admin)
  end
  
end