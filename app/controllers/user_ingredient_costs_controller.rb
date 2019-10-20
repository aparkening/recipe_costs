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
    redirect_non_users

    @user = User.find_by(id: params[:user_id])
    @user_ingredient = Ingredient.new
  end

# Create record
def create
  redirect_non_users
  
  @user = User.find_by(id: params[:user_id])
  params[:ingredient][:ingredient_id] = params[:ingredient][:id]

  # ingredient = Ingredient.find(params[:ingredient][:id])


  # Ensure current user can create for user
  require_authorization(@user)

    # Create ingredient
    @user_ingredient = @user.user_ingredient_costs.build(ing_params)
  
    if @user_ingredient.save
      redirect_to user_ingredients_path(@user)
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

  # Delete record
  def destroy
    redirect_non_users
    user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(user)

    # Find and destroy ingredient
    user_ingredient = user.user_ingredient_costs.find(params[:id])
    user_ingredient.destroy

    flash[:notice] = "Custom ingredient removed."
    redirect_to user_ingredients_path(user)
  end

  private

  def ing_params
    params.require(:ingredient).permit(:id, :ingredient_id, :cost, :cost_size, :cost_unit)
  end

end
