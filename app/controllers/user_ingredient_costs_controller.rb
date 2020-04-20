class UserIngredientCostsController < ApplicationController
  before_action :require_login
  before_action :redirect_non_users
  before_action :set_variables

  # All records
  def index
    # redirect_to ingredients_path if is_admin?

    @user_ingredient_costs = @user.user_ingredient_costs.order(name: :asc)
    @ingredients = Ingredient.all.order(name: :asc)
  end

  # Display new form
  def new
    @user_ingredient_cost = @user.user_ingredient_costs.build()
  end

  # Create record
  def create
    require_authorization(@user)

    # Create ingredient
    @user_ingredient_cost = @user.user_ingredient_costs.build(params.require(:user_ingredient_cost).permit(:ingredient_id, :cost, :cost_size, :cost_unit))

    # Redirect unless error
    if @user_ingredient_cost.save
      flash[:success] = "Success! #{@user_ingredient_cost.ingredient.name.titleize} created."
      redirect_to user_ingredients_path(@user)
    else
      render :new
    end
  end

  # Display record
  def show
    # redirect_to ingredients_path if is_admin?
    require_authorization(@user)

    # Find record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])

    # Redirect if error
    redirect_to user_ingredients_path(@user), alert: "Custom cost not found." if @user_ingredient_cost.nil?
  end

  # Display edit form
  def edit
    require_authorization(@user)

    # Find record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])

    # Redirect if error
    redirect_to user_ingredients_path(@user), alert: "Custom cost not found." if @user_ingredient_cost.nil?
  end

   # Update record
  def update
    require_authorization(@user)

    # Find and update record
    @user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])
    @user_ingredient_cost.update(params.require(:user_ingredient_cost).permit(:cost, :cost_size, :cost_unit))

    # Redirect unless error
    if @user_ingredient_cost.save
      flash[:success] = "Success! #{@user_ingredient_cost.ingredient.name.titleize} updated."
      redirect_to user_ingredients_path(@user)
    else
      render :edit
    end

  end

  # Delete record
  def destroy
    require_authorization(@user)

    # Find and destroy record
    user_ingredient_cost = @user.user_ingredient_costs.find(params[:id])
    flash[:notice] = "Success! #{user_ingredient_cost.ingredient.name.titleize} deleted."
    user_ingredient_cost.destroy
    redirect_to user_ingredients_path(@user)
  end

  private

  def set_variables
    @user = User.find_by(id: params[:user_id])
    @units = available_units  
  end

  def ing_params
    params.require(:user_ingredient_cost).permit(:cost, :cost_size, :cost_unit)
  end

end
