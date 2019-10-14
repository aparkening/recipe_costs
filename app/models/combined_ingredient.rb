class CombinedIngredient
  attr_reader :total_cost, :user, :ingredient

  ### Constants for conversion
  # More volume conversions in oz
  TSP = 0.16667
  TBSP = 0.5
  # A cup of all-purpose flour weighs 4 1/4 ounces or 120 grams
  
  ### Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables
  # Finally, calculate ingredient cost in this recipe

  def initialize(recipe_ingredient)
    # Set existing user and ingredient from input
    @user = recipe_ingredient.recipe.user
    @ingredient = recipe_ingredient.ingredient
    @amount = recipe_ingredient.ingredient_amount
    @unit = recipe_ingredient.ingredient_unit
    @total_cost = 0
    
    @cost, @cost_size, @cost_unit = nil, nil, nil, nil

    self.calc_costs
  end

  # Look for ingredients in UserIngredient first, then Ingredient
  def set_ingredients
    # Look for ingredient in user_ingredient_costs table
    user_details = @user.user_ingredient_costs.find_by(ingredient: @ingredient)

    if user_details
      # If ingredient in user_ingredient_costs table, grab cost, cost size, and cost unit
      @cost = user_details.cost
      @cost_size = user_details.cost_size
      @cost_unit = user_details.cost_unit
    else
      # Else grab cost, cost size, and cost unit from main ingredients table
      ingredient = Ingredient.find_by(id: @ingredient.id)
      @cost = ingredient.cost
      @cost_size = ingredient.cost_size
      @cost_unit = ingredient.cost_unit
    end
  end

  # Calculate base and total costs
  def calc_costs

    # Get specific ingredients for costs
    self.set_ingredients

    # Calculate base cost by dividing cost by size
    base_cost = @cost.to_f / @cost_size

    # If @unit == @cost_unit, multiply amount by base_cost
    if @unit == @cost_unit
      @total_cost = (base_cost * @amount).round(2)
    
    # Else convert units to calculate total cost
    else
      # If unit in Measured Weight database, convert
      if Measured::Weight.unit_names.include?(@unit)
        converted_amount = Measured::Weight.new(@amount, @unit).convert_to(@cost_unit).value.to_f          
      
      # Else look for teaspoons, tablespoons, or convert by volume
      else
        if @unit == "tsp"
          oz_amount = TSP * @amount
          converted_amount = Measured::Volume.new(oz_amount, "oz").convert_to(@cost_unit).value.to_f
        elsif @unit == "Tbsp"
          oz_amount = TBSP * @amount
          converted_amount = Measured::Volume.new(oz_amount, "oz").convert_to(@cost_unit).value.to_f
        else
          converted_amount = Measured::Volume.new(@amount, @unit).convert_to(@cost_unit).value.to_f
        end
      end

      @total_cost = (base_cost * converted_amount).round(2)
    end
  end

end