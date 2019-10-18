class RecipesController < ApplicationController
  before_action :require_login

  # Display all user's recipes
  def index
    if is_admin?
      @recipes = Recipe.all
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        flash[:alert] = "User not found."
        redirect_to root_path
      else
        @recipes = @user.recipes
      end
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Display user's recipe
  def show
    if is_admin?
      @recipe = Recipe.find(params[:id])
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      @recipe = @user.recipes.find_by(id: params[:id])
    else
      # User not authorized to see this 

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
    end
  end

  # Create new
  def create
    user = User.find_by(id: params[:user_id])
    recipe = user.recipes.build(recipe_params)

    if recipe.save
      redirect_to user_recipe_path(user, recipe)
    else
      flash[:error] = recipe.errors.full_messages
      redirect_to new_user_recipe_path(user, recipe)
    end
  end

  # Display update form
  def edit
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      
      # Require authorization
      require_authorization(user)

      if user.nil?
        flash[:error] = "User not found."
        redirect_to root_path
      else
        @recipe = user.recipes.find_by(id: params[:id])
        redirect_to user_recipes_path(user), alert: "Recipe not found." if @recipe.nil?
      end
    else
      flash[:error] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Update record
  def update
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
    
      @recipe = Recipe.find(params[:id])

      @recipe.update(recipe_params)

      if @recipe.save
        redirect_to @Recipe
      else
        render :edit
      end
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end
  end

  # Delete record
  def destroy
    user = User.find_by(id: params[:user_id])

    # Require authorization
    require_authorization(user)

    recipe = Recipe.find(params[:id])
    recipe.destroy
    flash[:notice] = "Recipe deleted."
    redirect_to user_recipes_path(user)
  end

  private

  # def find_user
  #   @user = User.find_by(id: params[:user_id])
  # end

  def recipe_params
    params.require(:recipe).permit(:name, :servings, :user_id)
  end

end