# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



u = User.new(name:"Steve Tester", password:"testing", role:"User", organization:"A&E Bakery")

i = Ingredient.new(name:"flour", cost:12.50, cost_size:5, cost_unit:"pounds")

u.recipes.build(name:"Apple Pie", servings:8) 