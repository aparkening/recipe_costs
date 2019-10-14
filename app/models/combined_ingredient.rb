class CombinedIngredient

  # More volume conversions in ounces
  # TSP = 0.16667
  # TBSP = 0.5
  # CUP = 0.0625 gal

  # A cup of all-purpose flour weighs 4 1/4 ounces or 120 grams

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
    @ingredient = recipe_ingredient.ingredient #ing1
    @name = @ingredient.name
    @amount = recipe_ingredient.ingredient_amount #amt
    @unit = recipe_ingredient.ingredient_unit #unit

    # weight = nil
    # Determine if weight or volume unit
    weight = if Measured::Weight.unit_names.include?(@unit)


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




      # Look for specific conversion in weight_volume_conversions table
      # conversion_data = WeightVolumeConversion.find_by(ingredient: @ingredient.id)

      # # If entry in weight_volume_conversions table, grab conversion data and convert
      # if conversion_data

      #   # Convert to grams
      #   if weight
          

      #   # Convert to liters
      #   else

      #   end

        # t.float "weight_size"
        # t.string "weight_unit"

        # t.float "vol_size"
        # t.string "vol_unit"

        # @cost = user_details.cost
        # @cost_size = user_details.cost_size
        # @cost_unit = user_details.cost_unit

      # # else use constants to convert
      # else 
        # Convert to grams
        if weight
          converted_size = Measured::Weight.new(@amount, @unit).convert_to(@cost_unit).value.to_f          
        # Convert to volume
        else
          converted_size = Measured::Volume.new(@amount, @unit).convert_to(@cost_unit).value.to_f
        end
      end
    end 
    
    # Calculate total cost
    # 50lb KA flour for $50
    # 1.5 cups of flour in brownies 

    base_cost = @cost/cost_size
    @total_cost = base_cost * converted_size

  end

end