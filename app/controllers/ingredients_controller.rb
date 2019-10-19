class IngredientsController < ApplicationController
  before_action :require_admin

  # All records
  def index
    @ingredients = Ingredient.all.order(name: :asc)
  end

  # Display new form
  def new
    if is_admin?
      @ingredient = Ingredient.new
    else 
      redirect_to root_path
    end
  end

  # Create record
  def create
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
  end

  # Ingredient import page
  def import
    Ingredient.import(params[:file])
    redirect_to ingredients_index_path, notice: "Success! File imported."
  end

  # Delete record
  def destroy

  end


  private

  def ing_params
    params.require(:ingredient).permit(:name, :cost, :cost_size, :cost_unit)
  end

end
