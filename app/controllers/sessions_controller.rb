class SessionsController < ApplicationController

  # Display login form
  def new
    @user = User.new
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

  # Google Oauth
  def googleAuth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    user = User.from_omniauth(access_token)
    log_in(user)
    # Access_token is used to authenticate request made from the rails application to the google server
    user.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    user.google_refresh_token = refresh_token if refresh_token.present?
    user.save
    session[:user_id] = user.id
    redirect_to user_path(user)
  end

end