class UserIngredientCostsController < ApplicationController
  before_action :require_login

  # All records
  def index
    redirect_to ingredients_path if is_admin?
    redirect_non_users

    @user = User.find_by(id: params[:user_id])
    @user_ingredients = @user.user_ingredient_costs
  end

  # Display new form
  def new
    @user_ingredient = Ingredient.new
  end

# Create record
def create
  redirect_non_users
  
  user = User.find_by(id: params[:user_id])
  ingredient = Ingredient.find(id: params[:ingredient_id])

  # Ensure current user can create for user
  require_authorization(user)

    # Create ingredient
    user_ingredient = UserIngredientCost.new(ing_params)
  
    if user_ingredient.save
      redirect_to user_ingredient_cost_path(user, user_ingredient)
    else
      # flash[:error] = ingredient.errors.full_messages
      # redirect_to new_ingredient_path
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def ing_params
    params.require(:user_ingredient).permit(:ingredient_id, :cost, :cost_size, :cost_unit)
  end

end
