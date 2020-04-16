class CombinedIngredient
  attr_reader :name, :amount, :amount_unit, :total_cost, :user, :ingredient, :base_cost_unit, :base_cost_size, :base_cost, :cost_ratio

  ### Constants for conversion not included in Measured gem
  TSP = 0.16667 #oz
  TBSP = 0.5 # oz
  CUP = 8 # oz
  EA = 1 # individual amount


  ### Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables
  # Then calculate ingredient cost for recipe
  def initialize(recipe_ingredient)
    @user = recipe_ingredient.recipe.user
    @ingredient = recipe_ingredient.ingredient
    @name = @ingredient.name
    @amount = recipe_ingredient.ingredient_amount
    @amount_unit = recipe_ingredient.ingredient_unit
    
    @total_cost, @cost_ratio, @base_cost, @base_cost_size, @base_cost_unit = 0, 0, 0, 0, ""

    # Get specific ingredients for costs
    self.set_ingredients

    # Calculate costs
    self.calc_costs
  end


  # Look for ingredients in UserIngredient first, then Ingredient
  def set_ingredients
    # Look for ingredient in user_ingredient_costs table
    user_details = @user.user_ingredient_costs.find_by(ingredient: @ingredient)

    if user_details
      # If ingredient in user_ingredient_costs table, grab cost, cost size, and cost unit
      @base_cost = user_details.cost
      @base_cost_size = user_details.cost_size
      @base_cost_unit = user_details.cost_unit
    else
      # Else grab cost, cost size, and cost unit from main ingredients table
      ingredient = Ingredient.find_by(id: @ingredient.id)
      @base_cost = ingredient.cost
      @base_cost_size = ingredient.cost_size
      @base_cost_unit = ingredient.cost_unit
    end
  end


  # Calculate base and total costs
  def calc_costs

    # Calculate base cost by dividing cost by size
    @cost_ratio = @base_cost.to_f / @base_cost_size

    # If @amount_unit == @base_cos_unit, no conversion needed. Multiply amount by base_cost
    if @amount_unit == @base_cost_unit || @amount_unit == "none"  || @amount_unit == "ea"
      @total_cost = (@cost_ratio * @amount).round(2)
  
    # Else convert units to calculate total cost
    else
      # If unit in Measured Weight database, convert
      if Measured::Weight.unit_names.include?(@amount_unit)
        converted_amount = Measured::Weight.new(@amount, @amount_unit).convert_to(@base_cost_unit).value.to_f          
      
      # If unit in Measured Volume database, convert
      elsif Measured::Volume.unit_names.include?(@amount_unit)
        converted_amount = Measured::Volume.new(@amount, @amount_unit).convert_to(@base_cost_unit).value.to_f
      
      # Else convert by constants
      else 
        case @amount_unit
        when "tsp"
          oz_amount = TSP * @amount
          converted_amount = Measured::Volume.new(oz_amount, "oz").convert_to(@base_cost_unit).value.to_f
        when "Tbsp"
          oz_amount = TBSP * @amount
        when "cup"
          oz_amount = CUP * @amount
        end

        converted_amount = Measured::Volume.new(oz_amount, "oz").convert_to(@base_cost_unit).value.to_f
      end

      @total_cost = (@cost_ratio * converted_amount).round(2)
    end
  end

end