class RecipesController < ApplicationController
  before_action :require_login
  before_action :redirect_non_users
  before_action :set_variables

  # Display all user's recipes
  def index
    if authorize(@user)
      if is_admin?
        # Admin search matches all recipes
        if params[:search]
          @recipes = Recipe.where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
        # Else show all recipes
        else
          @recipes = Recipe.all 
        end  
      else
        # User search matches this user's recipes
        if params[:search]
          @recipes = Recipe.users_recipes(@user).where('name LIKE ?', "%#{params[:search]}%").order('id DESC')

          flash[:alert] = "No recipe names match '#{params[:search]}'" if @recipes.empty?

        # Else show this user's recipes
        else
          @recipes = @user.recipes.includes(:recipe_ingredients) 
        end

        # Map ingredient costs with new_recipe hash
        @recipe_costs = @recipes.map do |recipe|
          new_recipe = {}

          new_recipe[:id] = recipe.id
          new_recipe[:user_id] = recipe.user_id
          new_recipe[:name] = recipe.name
          new_recipe[:servings] = recipe.servings

          # Get costs per ingredient
          new_recipe[:ingredients] = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

          # Calculate total cost
          new_recipe[:total_cost] = recipe.total_cost(new_recipe[:ingredients])

          # Calculate cost per serving
          new_recipe[:cost_per_serving] = recipe.cost_per_serving(new_recipe[:total_cost]) if recipe.servings

          new_recipe
        end 
      end
    end
  end

  # Display user's recipes by ingredient
  def by_ingredient  
    if authorize(@user)

      # If ingredient exists, find recipes that use it
      if Ingredient.exists?(params[:id])
        @ingredient = Ingredient.find(params[:id])
        
        # Show all recipes from ingredient for admins
        if is_admin?
          @recipes = Recipe.recipes_of_ingredient(params[:id])
        # Else only show this user's recipes
        else
          @recipes = @user.recipes.recipes_of_ingredient(params[:id])
        end
      
        # Show alert if ingredient not found in recipes
        flash[:alert] = "#{@ingredient.name.titleize} not found in your recipes." if @recipes.length == 0 

      # Else show all user's recipes  
      else
        flash[:alert] = "That ingredient wasn't found."
        @recipes = @user.recipes
      end

      render :index
    end
  end

  # Display new form
  def new
    if authorize(@user)
      @recipe = Recipe.new(user_id: params[:user_id])

      # Display 10 ingredient fields
      10.times{ @recipe.recipe_ingredients.build() }
    end
  end

  # Create new
  def create
    if authorize(@user)
      # Create recipe
      @recipe = @user.recipes.build(recipe_params)

      # Redirect unless error
      if @recipe.save
        flash[:success] = "Success! #{@recipe.name.titleize} created."
        redirect_to user_recipe_path(@user, @recipe)
      else
        render :new
      end
    end
  end

  # Display record
  def show
    if authorize(@user)
      # Find recipe within all recipes for admin; within subset for user
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
      
      # Redirect if error
      else
        redirect_to user_recipes_path(@user), alert: "Recipe not found."
      end
    end
  end

  # Display update form
  def edit
    if authorize(@user)
      # Search all recipes for admin; subset for user
      if is_admin?
        @recipe = Recipe.find_by(id: params[:id])
      else 
        @recipe = @user.recipes.find_by(id: params[:id])
      end

      # Redirect if recipe not found
      if @recipe.nil?
        redirect_to user_recipes_path(@user), alert: "Recipe not found." 
      # Else display edit form with two blank ingredients
      else
        2.times{ @recipe.recipe_ingredients.build() }
      end
    end
  end

  # Update record
  def update
    if authorize(@user)
      # Find and update record
      @recipe = Recipe.find_by(id: params[:id])
      @recipe.update(recipe_params)

      # Redirect unless error
      if @recipe.save
        flash[:success] = "Success! #{@recipe.name.titleize} updated."
        redirect_to user_recipe_path(@user, @recipe)
      else
        render :edit
      end
    end
  end

  # Import CSVs
  # user_recipes_import_path
  def import
    if params[:file] && authorize(@user)
      Recipe.import(params[:file], @user)

      flash[:success] = "Success! File imported."
      redirect_to user_recipes_path(@user)
    end
  end

  # Delete record
  def destroy
    if authorize(@user)
      # Find record
      recipe = Recipe.find_by(id: params[:id])
      
      # Destroy unless error
      if recipe
        # Manually delete recipe_ingredients because dependent: :destroy isn't working.
        recipe.recipe_ingredients.each do |ri|
          ri.destroy
        end
        flash[:success] = "Success! #{recipe.name} deleted."
        recipe.destroy
      else
        flash[:alert] = "Recipe not found."
      end

      redirect_to user_recipes_path(@user)
    end
  end

  private

  def set_variables
    @user = User.find_by(id: params[:user_id])
    @units = available_units  
  end

  def recipe_params
    params.require(:recipe).permit(:name, :servings, :user_id, recipe_ingredients_attributes: [:user_id, :ingredient_id, :ingredient_amount, :ingredient_unit, :_destroy, :id])
  end

end