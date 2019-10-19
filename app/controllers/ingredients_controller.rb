class IngredientsController < ApplicationController
  before_action :require_admin
  before_action :set_ing, only: [:edit, :update, :destroy]

  # All records
  def index
    @ingredients = Ingredient.all.order(name: :asc)
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

  def set_ing
    @ingredient = Ingredient.find(params[:id])
  end

  def ing_params
    params.require(:ingredient).permit(:name, :cost, :cost_size, :cost_unit)
  end

end
