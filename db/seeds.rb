# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


### Console Testing
user1 = User.last

user1_recipe = user1.recipes.last
ing1 = Ingredient.last

recipe1_ing1 = user1_recipe.recipe_ingredients.last

user1_ing1 = user1.user_ingredient_costs.last

combo_ing1 = CombinedIngredient.new(recipe1_ing1)


### Build seeds

# Make User, recipe, ingredient
user1 = User.create(name:"Steve Tester", password:"testing", role:"User", organization:"A&E Bakery")
user1_r1 = user1.recipes.create(name:"Apple Pie", servings:8) 
ing1 = Ingredient.create(name:"flour", cost:12.50, cost_size:5, cost_unit:"lb")

# Add ingredient to recipe
r1_ing1 = user1_r1.recipe_ingredients.create(ingredient:ing1, ingredient_amount:6.376, ingredient_unit:"oz")
  # get name with user1_r1.recipe_ingredients.first.ingredient.name

# Make ingredient cost specific to user.
user1_ing1 = user1.user_ingredient_costs.create(ingredient:ing1, cost:14.00, cost_size:1, cost_unit:"lb")

# Set CombinedIngredient object that combines data in Ingredient and UserIngredient
combo_ing1 = CombinedIngredient.new(r1_ing1)

# Add flag to ingredient
flag1 = user1.flags.create(ingredient: ing1, note: "Flour is spelled wrong.")

# Add category
cat1 = user1.categories.create(name:"Desserts") 

# Add recipe to category
cat1.recipes << user1_r1

# Add weight volume conversion to weight_volume_conversion table
convert1 = WeightVolumeConversion.create(ingredient:ing1, weight_size: 4.25, weight_unit: "oz", vol_size: 1, vol_unit: "c")

# Find all recipes (from user) that ingredient is used in
ing1.recipes.where(user: user1)

# Calculate recipe cost using weight_volume_conversion table
