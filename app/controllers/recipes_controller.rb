class RecipesController < ApplicationController
  before_action :require_login

  # Display all user's recipes
  def index
    if is_admin?
      # @recipes = Recipe.all
      @user = User.find_by(id: params[:user_id])
      @recipes = @user.recipes
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        flash[:alert] = "User not found."
        redirect_to root_path
      else
        @recipes = @user.recipes
        # @recipes = Recipe.recipes_costs(@user)
      end
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Display record
  def show
    if is_admin?
      @recipe = Recipe.find(params[:id])
      @user = @recipe.user
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      # Require authorization
      require_authorization(@user)

      @recipe = @user.recipes.find_by(id: params[:id])
      # @recipe_ingredient_costs = {}
      @recipe_total = 0

      @recipe_ingredient_costs = @recipe.recipe_ingredients.map do |ingredient|
        combo_ingredient = CombinedIngredient.new(ingredient)
        total_cost = combo_ingredient.total_cost
      
        @recipe_total += combo_ingredient.total_cost

        total_cost
      end 
      # @recipe_cost = Recipe.recipes_costs(@user)
    end

    if @recipe.nil?
      flash[:alert] = "Recipe not found."
      redirect_to user_recipes_path(@user)
    end
  end

  # Display new form
  def new
    if params[:user_id] && !User.exists?(params[:user_id])
      flash[:error] = "User not found."
      redirect_to users_path
    else
      @user = User.find_by(id: params[:user_id])
      @recipe = Recipe.new(user_id: params[:user_id])
      
      10.times{ @recipe.recipe_ingredients.build() }
    end
  end

  # Create new
  def create
    # Set user by params
    user = User.find_by(id: params[:user_id])

    # Ensure current user can create for user
    require_authorization(user)

    # Create recipe
    @recipe = user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to user_recipe_path(user, @recipe)
    else
      # flash[:error] = @recipe.errors.full_messages
      # redirect_to new_user_recipe_path(user, recipe)
      render :new
    end
  end

  # Display update form
  def edit
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      
      # Require authorization
      require_authorization(@user)

      if @user.nil?
        flash[:error] = "User not found."
        redirect_to root_path
      else
        @recipe = @user.recipes.find_by(id: params[:id])

        2.times{ @recipe.recipe_ingredients.build() }

        redirect_to user_recipes_path(@user), alert: "Recipe not found." if @recipe.nil?
      end
    else
      flash[:error] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Update record
  def update

    if params[:user_id]
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
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Import CSVs
  # user_recipes_import_path
  def import
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      require_authorization(user)

      Recipe.import(params[:file], user)

      redirect_to user_recipes_path(user), notice: "Success! File imported."
    else
      flash[:alert] = "User not found."
      redirect_to root_path
    end
  end

  # Delete record
  def destroy
    user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(user)

    recipe = Recipe.find(params[:id])
    
    # Manually delete recipe_ingredients, since dependet: :destroy isn't working.
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