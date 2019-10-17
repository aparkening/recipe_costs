class SessionsController < ApplicationController

  # Display login form
  def new
    # @user = User.all
  end

  # Log user in
  def create
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "Success! Welcome back." 
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:error] = "Credentials don't work. Please check your name and password." 
      redirect_to login_path
    end
  end

  # Log user out
  def destroy
    session.clear
    redirect_to root_path
  end

end