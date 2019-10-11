class CombinedIngredient

  # Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables
  def initialize(recipe_ingredient)
    # Find user
    @user = recipe_ingredient.user

    # Find ingredient
    @ingredient = recipe_ingredient.ingredient

    # If ingredient in user_ingredient_costs table, grab it's cost, cost size, and cost unit
    # Find
    # if user.user_ingredient_costs == @ingredient

    # Else grab cost, cost size, and cost unit from ingredients table
    # Find
    

  
  end


# Could make custom ingredient class
  # - Merge ingredient name, amount, costs, etc.
  # initialize with ingredient object (from recipe_ingredient table) and user_costs object

  # custom initialize(recipe_ingredient)

  # recipe.user
  # if user_ingredient_costs == recipe_ingredient
  # 
#####


end
