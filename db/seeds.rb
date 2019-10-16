# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


### Console Testing
# user1 = User.last

# user1_recipe = user1.recipes.last
# ing1 = Ingredient.last

# recipe1_ing1 = user1_recipe.recipe_ingredients.last

# user1_ing1 = user1.user_ingredient_costs.last

# combo_ing1 = CombinedIngredient.new(recipe1_ing1)


### Build seeds

# Users
admin = User.create(name: "David Baker", password: "testing123", password_confirmation: "testing123", role: "admin", organization: "The Culinary Institute of America")

paul = User.create(name: "Paul Hollywood", password: "testing123", password_confirmation: "testing123", organization: "Great British Bake Off")

prue = User.create(name: "Prue Leith", password: "testing123", password_confirmation: "testing123", organization: "Great British Bake Off")

mary = User.create(name: "Mary Berry", password: "testing123", password_confirmation: "testing123", organization: "Great British Bake Off")

morimoto = User.create(name: "Masaharu Morimoto", password: "testing123", password_confirmation: "testing123", organization: "Morimoto's")

jamie = User.create(name: "Jamie Oliver", password: "testing123", password_confirmation: "testing123")

nigel = User.create(name: "Nigel Slater", password: "testing123", password_confirmation: "testing123")

harold = User.create(name: "Harold McGee", password: "testing123", password_confirmation: "testing123")

rosie = User.create(name: "Judy Rosenberg", password: "testing123", password_confirmation: "testing123", organization: "Rosie's Bakery")

peter = User.create(name: "Peter Reinhart", password: "testing123", password_confirmation: "testing123", organization: "Johnson and Wales University")


# Recipes
white_bread = paul.recipes.create(name:"White Bread", servings:8)
english_muffins = paul.recipes.create(name:"English Muffins", servings:60)

choc_torte = prue.recipes.create(name:"Flourless Chocolate Torte", servings:64) 

puff_pastry = mary.recipes.create(name:"Puff Pastry", servings:92)
ginger_cake = mary.recipes.create(name:"Ginger Cake", servings:18)
 
chicken_teriyaki = morimoto.recipes.create(name:"Chicken Teriyaki", servings:4)
onigiri = morimoto.recipes.create(name:"Chicken Teriyaki Onigiri", servings:4)
tamagoyaki = morimoto.recipes.create(name:"Tamagoyaki", servings:4)

apple_cake = jamie.recipes.create(name:"Apple Cake", servings:24)  

apple_pie = nigel.recipes.create(name:"Apple Pie", servings:8) 
pumpkin_scones = nigel.recipes.create(name:"Pumpkin Scones", servings:8) 

ginger_cookies = harold.recipes.create(name:"Ginger Cookies", servings:186) 

choc_chip_cookies = rosie.recipes.create(name:"Chocolate Chip Cookies", servings:240)
macaroons = rosie.recipes.create(name:"Macaroons", servings:60)

cinn_raisin_bread = peter.recipes.create(name:"Cinnamon Raisin Bread", servings:8) 
french_bread = peter.recipes.create(name:"French Bread", servings:6)
pizza_dough = peter.recipes.create(name:"Pizza Dough", servings:6)


# Ingredients (from ingredients.csv)


# Add ingredients to recipes (from recipes.csv)
# For each recipe, find_by_name, then loop through recipe ingredients to add each ingredient:
  # recipe.recipe_ingredients.create(ingredient:Ingredient.find_by_name("flour"), ingredient_amount:6.376, ingredient_unit:"oz")




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
