class IngredientsController < ApplicationController
  before_action :require_admin
  before_action :set_variables

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
    # Downcase name
    params[:ingredient][:name] = params[:ingredient][:name].downcase
    
    # Create ingredient
    @ingredient = Ingredient.new(ing_params)

    # Redirect unless error
    if @ingredient.save
      flash[:success] = "Success! #{@ingredient.name.titleize} created."
      redirect_to ingredients_path
    else
      render :new
    end
  end

  # Display edit form
  def edit
    # Find record
    @ingredient = Ingredient.find_by(id: params[:id])

    # Redirect if error
    redirect_to ingredients_path, alert: "Ingredient not found." if @ingredient.nil?
  end

  # Update record
  def update
    # Downcase name
    params[:ingredient][:name] = params[:ingredient][:name].downcase

    # Find and update record
    @ingredient = Ingredient.find_by(id: params[:id])
    @ingredient.update(ing_params)

    # Redirect unless error
    if @ingredient.save
      flash[:success] = "Success! #{@ingredient.name.titleize} updated."
      redirect_to ingredients_path
    else
      render :edit
    end  
  end

  # Import CSVs
  def import
    Ingredient.import(params[:file])
    redirect_to ingredients_path, notice: "Success! File imported."
  end

  # Delete record
  def destroy
    # Find record
    ingredient = Ingredient.find_by(id: params[:id])

    # Destroy unless error
    if ingredient
      flash[:success] = "Success! #{ingredient.name.titleize} deleted."
      ingredient.destroy
    else
      flash[:alert] = "Ingredient not found."
    end

    redirect_to ingredients_path
  end

  private

  def set_variables
    @user = current_user
    @units = available_units  
  end

  def ing_params
    params.require(:ingredient).permit(:name, :cost, :cost_size, :cost_unit)
  end

end
