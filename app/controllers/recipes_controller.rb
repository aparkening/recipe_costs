class RecipesController < ApplicationController
  before_action :require_login

  # Display all user's recipes
  def index
    if is_admin?
      @recipes = Recipe.all
      @user = User.find_by(id: params[:user_id])

      # Admin search matches all recipes
      if params[:search]
        # If search, find results
		    @recipes = Recipe.where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
      end
    else
      redirect_non_users      
      @user = User.find_by(id: params[:user_id])

      if params[:search]
        # If search, find results
		    @recipes = Recipe.users_recipes(@user).where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
      else
        # Show everything
        @recipes = @user.recipes.includes(:recipe_ingredients) 
      end

      # Map ingredient costs
      @recipe_costs = @recipes.map do |recipe|
        new_recipe = {}

        new_recipe[:id] = recipe.id
        new_recipe[:user_id] = recipe.user_id
        new_recipe[:name] = recipe.name
        new_recipe[:servings] = recipe.servings

        # Get costs per ingredient
        new_recipe[:ingredients] = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

        # Calculate total cost
        # cost << recipe.total_cost(recipe_ingredients)
        new_recipe[:total_cost] = recipe.total_cost(new_recipe[:ingredients])

        # Calculate cost per serving
        # cost << recipe.cost_per_serving(recipe.total_cost(recipe_ingredients)) if recipe.servings
        new_recipe[:cost_per_serving] = recipe.cost_per_serving(new_recipe[:total_cost]) if recipe.servings

        new_recipe
      end 

      # binding.pry
      # @recipes = Recipe.recipes_costs(@user)
    end
  end

  # Display user's recipes by ingredient
  def by_ingredient
    redirect_non_users
        
    @user = User.find_by(id: params[:user_id])
  
    # If ingredient exists, find recipes that use it
    if Ingredient.exists?(params[:id])
      @ingredient = Ingredient.find(params[:id])
      if is_admin?
        # Show all recipes from ingredient for admins
        @recipes = Recipe.recipes_of_ingredient(params[:id])
      else
        # Only show user's recipes
        @recipes = @user.recipes.recipes_of_ingredient(params[:id])
      end
    else
      flash[:alert] = "That ingredient wasn't found."

      # Else show all users' recipes
      @recipes = @user.recipes
    end

    render 'index'
  end


  # Display record
  def show
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

    # If recipe exists, iterate through ingredients to calculate each cost and combine into total cost and cost per serving.
    if @recipe
      # Map costs for each ingredient
      @recipe_ingredients = @recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Total recipe cost
      @recipe_total_cost = @recipe.total_cost(@recipe_ingredients)
      
      # Cost per serving
      @recipe_cost_per_serving = @recipe.cost_per_serving(@recipe_total_cost) if @recipe.servings
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
    @units = available_units  

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
    @units = available_units  
    
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