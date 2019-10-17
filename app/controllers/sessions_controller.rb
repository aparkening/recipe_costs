class SessionsController < ApplicationController

  # Display login form
  def new
    @user = User.all
  end

  # Log user in
  def create
    @user = User.find(params[:user_name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to signin_path
    end
  end

  # Log user out
  def destroy
    session.clear
    redirect_to root_path
  end

end