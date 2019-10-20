class UserIngredientCostsController < ApplicationController
  before_action :require_login

  # All records
  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        flash[:alert] = "User not found."
        redirect_to root_path
      else
        @ingredients = @user.user_ingredient_costs
        # @recipes = Recipe.recipes_costs(@user)
      end
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
