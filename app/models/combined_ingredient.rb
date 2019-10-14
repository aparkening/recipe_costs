class CombinedIngredient
  attr_reader :total_cost, :user, :ingredient, :name

  # Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables
  # Calculate ingredient cost in this recipe


  ### Constants for conversion
  # More volume conversions in ounces
  # TSP = 0.16667
  # TBSP = 0.5
  # A cup of all-purpose flour weighs 4 1/4 ounces or 120 grams
  

  def initialize(recipe_ingredient)
    # Set existing user and ingredient from input
    @user = recipe_ingredient.recipe.user
    @ingredient = recipe_ingredient.ingredient
    @name = @ingredient.name
    @amount = recipe_ingredient.ingredient_amount
    @unit = recipe_ingredient.ingredient_unit
    @total_cost = 0

    # weight = nil
    # Determine if weight or volume unit
    @weight = Measured::Weight.unit_names.include?(@unit)

    
    self.calc_cost
  end


  # Add ingredient to recipe through CombinedIngredient object, instead of Ingredient and UserIngredient
  # Want to access:
  #   ingredient cost, cost size, cost unit, and name
  #   recipe_ingredient amount and unit
  #   weight_volume_conversion weight size, weight unit, volume size, and volume unit

  # Calculate ingredient cost
  def calc_cost

    # Look for ingredient in user_ingredient_costs table
    user_details = @user.user_ingredient_costs.find_by(ingredient: @ingredient)

    if user_details
      # If ingredient in user_ingredient_costs table, grab cost, cost size, and cost unit
      cost = user_details.cost
      cost_size = user_details.cost_size
      cost_unit = user_details.cost_unit
    else
      # Else grab cost, cost size, and cost unit from main ingredients table
      ingredient = Ingredient.find_by(id: @ingredient.id)
      cost = ingredient.cost
      cost_size = ingredient.cost_size
      cost_unit = ingredient.cost_unit
    end

    # Find total ingredient cost by amount and weight_volume_conversion table
    # If @unit is not the same as @cost_unit

    if @unit != cost_unit

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
        if @weight
          converted_size = Measured::Weight.new(@amount, @unit).convert_to(cost_unit).value.to_f          
        # Convert to volume
        else
          converted_size = Measured::Volume.new(@amount, @unit).convert_to(cost_unit).value.to_f
        end
      # end
      else
        converted_size = @amount
      end


    # Calculate total cost
    # 50lb KA flour for $50
    # 1.5 cups of flour in brownies 


    binding.pry

    base_cost = cost.to_f / cost_size
    @total_cost = base_cost * converted_size 

  end

end