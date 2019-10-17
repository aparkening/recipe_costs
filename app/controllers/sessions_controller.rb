class SessionsController < ApplicationController

  # Display login form
  def new
    @user = User.all
  end

  # Log user in
  def create
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to login_path, error: "Credentials don't work. Please check your name and password." 
    end
  end

  # Log user out
  def destroy
    session.clear
    redirect_to root_path, notice: "Successfully logged out"
  end

end