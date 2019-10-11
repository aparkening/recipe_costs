# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


# Make User, recipe, ingredient
user1 = User.create(name:"Steve Tester", password:"testing", role:"User", organization:"A&E Bakery")

user1_r1 = user1.recipes.create(name:"Apple Pie", servings:8) 

ing1 = Ingredient.create(name:"flour", cost:12.50, cost_size:5, cost_unit:"pounds")

# Add ingredient to recipe
r1_ing1 = user1_r1.recipe_ingredients.build(ingredient:ing1, ingredient_amount:1.5, ingredient_unit:"cups")
  # get name with user_r.recipe_ingredients.first.ingredient.name

# Make ingredient cost specific to user.
user1_ing1 = user1.user_ingredient_costs.build(ingredient:ing1, cost:14.00, cost_size:1, cost_unit:"pounds")


### Future:
# Add ingredient to recipe through CombinedIngredient object, instead of Ingredient and UserIngredient
# Want to access:
# ingredient cost, cost size, cost unit, and name
# recipe_ingredient amount and unit
# weight_volume_conversion weight size, weight unit, volume size, and volume unit
# Calculate: ingredient cost in this recipe
combo_ing1 = CombinedIngredient.new(r1_ing1)


### Test
# - User add flag to ingredient
# - User add category
# - User add recipe to category
# - Add weight volume conversion to weight_volume_conversion table
# - Find all recipes (from user) that ingredient is used in
# - Calculate recipe cost using weight_volume_conversion table
