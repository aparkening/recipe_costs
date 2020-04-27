class ErrorsController < ApplicationController
  before_action :set_user

  # 404 page 
  def not_found
    @error = {title: "Page Not Found", msg: "The page you were looking for doesn't exist. Please select another page from the navigation above."}
    render :error
  end

  # 422 page
  def unacceptable
    @error = {title: "Change Rejected", msg: "Maybe you tried to change something you didn't have access to. Please select another page from the navigation above or contact the site owner."}
    render :error
  end

  # 500 page
  def internal_error
    @error = {title: "Internal Server Error", msg: "Something went wrong. Please select another page from the navigation above or contact the site owner."}
    render :error
  end


  private

  def set_user
    @user = current_user if current_user
  end

end