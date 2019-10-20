class IngredientsController < ApplicationController
  before_action :require_admin, only: [:import]
  # before_action :set_ing, only: [:edit, :update, :destroy]

  # All records
  def index
    # If admin user, show all ingredients
    if is_admin?
      @ingredients = Ingredient.all.order(name: :asc)

    # If other user, show own ingredient lists
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        flash[:alert] = "User not found."
        redirect_to root_path
      else
        @ingredients = @user.user_ingredients
        # @recipes = Recipe.recipes_costs(@user)
      end
    else
      flash[:alert] = "Recipes need a user."
      redirect_to root_path
    end



    def set_ing

    end




  end

  # Display new form
  def new
    
    
    @ingredient = Ingredient.new


  end

  # Create record
  def create
    # Make name lowercase
    params[:ingredient][:name] = params[:ingredient][:name].downcase
    ingredient = Ingredient.new(ing_params)
    if ingredient.save
      redirect_to ingredients_path
    else
      flash[:error] = ingredient.errors.full_messages
      redirect_to new_ingredient_path
      # render 'new'
    end
  end

  # Display edit form
  def edit
  end

  # Update record
  def update
    # Make name lowercase
    params[:ingredient][:name] = params[:ingredient][:name].downcase
    @ingredient.update(ing_params)

    if @ingredient.save
      flash[:success] = "Success! #{@ingredient.name.capitalize} updated."
      redirect_to ingredients_path
    else
      flash[:error] = @ingredient.errors.full_messages
      redirect_to edit_ingredient_path(@ingredient)
    end  
  end

  # Import CSVs
  def import
    Ingredient.import(params[:file])
    redirect_to ingredients_path, notice: "Success! File imported."
  end

  # Delete record
  def destroy
    ingredient = Ingredient.find(params[:id])
    ingredient.destroy
    flash[:notice] = "Ingredient deleted."
    redirect_to ingredients_path
  end


  private

  def ing_params
    params.require(:ingredient).permit(:name, :cost, :cost_size, :cost_unit)
  end

end
