class CombinedIngredient

  # Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables

  # Add ingredient to recipe through CombinedIngredient object, instead of Ingredient and UserIngredient
  # Want to access:
  #   ngredient cost, cost size, cost unit, and name
  #   recipe_ingredient amount and unit
  #   weight_volume_conversion weight size, weight unit, volume size, and volume unit
  # Calculate: ingredient cost in this recipe

  def initialize(recipe_ingredient)
    # Set existing user and ingredient from input
    @user = recipe_ingredient.user
    @ingredient = recipe_ingredient.ingredient
    @name = @ingredient.name
    @amount = recipe_ingredient.ingredient_amount
    @unit = recipe_ingredient.ingredient_unit

    # Look for ingredient in user_ingredient_costs table
    user_details = @user.UserIngredientCost.find_by(id: @ingredient.id)

    if user_details
      # If ingredient in user_ingredient_costs table, grab cost, cost size, and cost unit
      @cost = user_details.cost
      @cost_size = user_details.cost_size
      @cost_unit = user_details.cost_unit
    else
      # Else grab cost, cost size, and cost unit from main ingredients table
      @cost = @ingredient.cost
      @cost_size = @ingredient.cost_size
      @cost_unit = @ingredient.cost_unit
    end

    # Find total ingredient cost by amount and weight_volume_conversion table
    # If @unit is not the same as @cost_unit
    if @unit != @cost_unit

      # Find @ingredient.id in weight_volume_conversions table
      conversion_data = WeightVolumeConversion.find_by(id: @ingredient.id)

      # If entry in weight_volume_conversions table, grab conversion data and convert
      if conversion_data
        # t.float "weight_size"
        # t.string "weight_unit"

        # t.float "vol_size"
        # t.string "vol_unit"

        # @cost = user_details.cost
        # @cost_size = user_details.cost_size
        # @cost_unit = user_details.cost_unit

      # else use constants to convert
      else 

      end
    end 
    
    # Calculate total cost
    # 50lb KA flour for $50
    # 1.5 cups of flour in brownies 
    
    # @total_cost = @cost * converted_amount


  end

end