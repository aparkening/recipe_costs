class RecipesController < ApplicationController
  before_action :require_login

  # Display all user's recipes
  def index
    if is_admin?
      @recipes = Recipe.all
      @user = User.find_by(id: params[:user_id])
      # @recipes = @user.recipes
    else
      redirect_non_users
      
      @user = User.find_by(id: params[:user_id])
      @recipes = @user.recipes
      # @recipes = Recipe.recipes_costs(@user)
    end
  end

  # Display user's recipes by ingredient
  def by_ingredient
    redirect_non_users
    
    binding.pry
    
    @user = User.find_by(id: params[:user_id])
    @ingredient = Ingredient.find(params[:id])
    @recipes = @user.recipes.recipes_of_ingredient(params[:id])

    render 'index'
  end


  # Display record
  def show
    # if is_admin?
    #   @recipe = Recipe.find(params[:id])
    #   @user = @recipe.user
    # else
    redirect_non_users
    @user = User.find_by(id: params[:user_id])
    # Require authorization
    require_authorization(@user)

    # Search all recipes for admin; subset for user
    if is_admin?
      @recipe = Recipe.find_by(id: params[:id])
    else 
      @recipe = @user.recipes.find_by(id: params[:id])
    end

    if @recipe
      # ** Mark: Make more MVC **
      # Manually calculate costs
      @recipe_total = 0
      @recipe_ingredient_costs = @recipe.recipe_ingredients.map do |ingredient|
        # Get right ingredient with latest costs
        combo_ingredient = CombinedIngredient.new(ingredient)

        # Get ingredient cost
        total_cost = combo_ingredient.total_cost
  
        # Add to recipe total
        @recipe_total += combo_ingredient.total_cost
        
        total_cost
      end 
      @recipe_total = @recipe_total.round(2)
      @cost_per_serving = (@recipe_total/@recipe.servings).round(2) if @recipe.servings
    else
      flash[:alert] = "Recipe not found."
      redirect_to user_recipes_path(@user)
    end
  end

  # Display new form
  def new
    redirect_non_users
    @user = User.find_by(id: params[:user_id])

    @recipe = Recipe.new(user_id: params[:user_id])
      
    # Display 10 ingredient fields
    10.times{ @recipe.recipe_ingredients.build() }
  end

  # Create new
  def create
    redirect_non_users
    @user = User.find_by(id: params[:user_id])

    # Ensure current user can create for user
    require_authorization(@user)

    # Create recipe
    @recipe = @user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to user_recipe_path(@user, @recipe)
    else
      # flash[:error] = @recipe.errors.full_messages
      # redirect_to new_user_recipe_path(user, recipe)
      render :new
    end
  end

  # Display update form
  def edit
    redirect_non_users
    @user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(@user)

    # Search all recipes for admin; subset for user
    if is_admin?
      @recipe = Recipe.find_by(id: params[:id])
    else 
      @recipe = @user.recipes.find_by(id: params[:id])
    end

    # Add two blank ingredients to add more on edit screen
    2.times{ @recipe.recipe_ingredients.build() }

    redirect_to user_recipes_path(@user), alert: "Recipe not found." if @recipe.nil?
  end

  # Update record
  def update
    redirect_non_users
    @user = User.find_by(id: params[:user_id])
    
    # Require authorization
    require_authorization(@user)

    @recipe = Recipe.find(params[:id])
    @recipe.update(recipe_params)

    if @recipe.save
      flash[:success] = "Success! Recipe updated."
      redirect_to user_recipe_path(@user, @recipe)
    else
      # flash[:error] = recipe.errors.full_messages
      # redirect_to edit_user_recipe_path(user, recipe)
      render :edit
    end
  end

  # Import CSVs
  # user_recipes_import_path
  def import
    redirect_non_users
    
    user = User.find_by(id: params[:user_id])
    require_authorization(user)

    Recipe.import(params[:file], user)

    redirect_to user_recipes_path(user), notice: "Success! File imported."
  end

  # Delete record
  def destroy
    redirect_non_users
    user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(user)

    recipe = Recipe.find(params[:id])
    
    # Manually delete recipe_ingredients, since dependent: :destroy isn't working.
    recipe.recipe_ingredients.each do |ri|
      ri.destroy
    end

    recipe.destroy
    flash[:notice] = "Recipe deleted."
    redirect_to user_recipes_path(user)
  end

  private

  # def find_user
  #   @user = User.find_by(id: params[:user_id])
  # end

  def recipe_params
    params.require(:recipe).permit(:name, :servings, :user_id, recipe_ingredients_attributes: [:user_id, :ingredient_id, :ingredient_amount, :ingredient_unit, :_destroy, :id])
  end

end