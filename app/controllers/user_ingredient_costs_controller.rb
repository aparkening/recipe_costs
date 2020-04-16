class UserIngredientCostsController < ApplicationController
  before_action :require_login

  # All records
  def index
    redirect_to ingredients_path if is_admin?
    redirect_non_users

    @user = User.find_by(id: params[:user_id])
    @user_ingredient_costs = @user.user_ingredient_costs.order(name: :asc)
    @ingredients = Ingredient.all.order(name: :asc)
  end

  # Display new form
  def new
    redirect_non_users

    @user = User.find_by(id: params[:user_id])
    @user_ingredient_cost = @user.user_ingredient_costs.build()
  end

  # Create record
  def create
    redirect_non_users

    # Set user
    @user = User.find_by(id: params[:user_id])
    
    # Ensure current user is authorized
    require_authorization(@user)

    # Create ingredient
    @user_ingredient_cost = @user.user_ingredient_costs.build(params.require(:user_ingredient_cost).permit(:ingredient_id, :cost, :cost_size, :cost_unit))

    # Redirect unless error
    if @user_ingredient_cost.save
      flash[:success] = "Success! Custom cost created."
      redirect_to user_ingredients_path(@user)
    else
      render :new
    end
  end

  # Display record
  def show
    redirect_to ingredients_path if is_admin?
    redirect_non_users
    
    @user = User.find_by(id: params[:user_id])
    # Require authorization
    require_authorization(@user)

    # Find record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])

    # Redirect if error
    redirect_to user_ingredients_path(@user), alert: "Custom cost not found." if @user_ingredient_cost.nil?
  end

  # Display update form
  def edit
    redirect_non_users
    @user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(@user)

    # Find record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])

    # Redirect if error
    redirect_to user_ingredients_path(@user), alert: "Custom cost not found." if @user_ingredient_cost.nil?
  end

   # Update record
  def update
    redirect_non_users
    @user = User.find_by(id: params[:user_id])
    
    # Require authorization
    require_authorization(@user)

    # Find and update record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])
    @user_ingredient_cost.update(params.require(:user_ingredient_cost).permit(:cost, :cost_size, :cost_unit))

    if @user_ingredient_cost.save
      flash[:success] = "Success! Custom cost updated."
      redirect_to user_ingredients_path(@user)
    else
      # flash[:error] = recipe.errors.full_messages
      # redirect_to edit_user_recipe_path(user, recipe)
      render :edit
    end

  end

  # Delete record
  def destroy
    redirect_non_users
    user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(user)

    # Find and destroy record
    user_ingredient_cost = user.user_ingredient_costs.find(params[:id])
    user_ingredient_cost.destroy

    flash[:notice] = "Custom cost removed."
    redirect_to user_ingredients_path(user)
  end

  private

  def ing_params
    params.require(:user_ingredient_cost).permit(:cost, :cost_size, :cost_unit)
  end

end
