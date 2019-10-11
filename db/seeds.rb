# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


# Make User, recipe, ingredient
user = User.create(name:"Steve Tester", password:"testing", role:"User", organization:"A&E Bakery")

user_r = user.recipes.create(name:"Apple Pie", servings:8) 

ing = Ingredient.create(name:"flour", cost:12.50, cost_size:5, cost_unit:"pounds")

# Add ingredient to recipe
user_r.recipe_ingredients.build(ingredient:ing, ingredient_amount:1.5, ingredient_unit:"cups")
  # get name with user_r.recipe_ingredients.first.ingredient.name

# Make ingredient cost specific to user.
user_ing = user.user_ingredient_costs.build(ingredient:ing, cost:14.00, cost_size:1, cost_unit:"pounds")


# Could make custom ingredient class
  # - Merge ingredient name, amount, costs, etc.
  # initialize with ingredient object (from recipe_ingredient table) and user_costs object

  # custom initialize(recipe_ingredient)

  # recipe.user
  # if user_ingredient_costs == recipe_ingredient
  # 
#####