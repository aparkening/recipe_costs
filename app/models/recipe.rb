class Recipe < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { 
    scope: %i[user_id],
    message: 'must be unique.' 
  }

  # Scope to return user's recipes
  scope :users_recipes, -> (user) {where(user_id: user.id)}
  
  # Scope to return user's recipes by ingredient
  scope :recipes_of_ingredient, -> (ingredient) { joins(:ingredients).where(ingredients: {id: ingredient.id}) }



  # This works:
  # ing1.recipes.where(user: user1)

  # This works:
  # def self.recipes_of_ingredient(ingredient, user)
  #   Recipe.where(user_id: user.id).joins(:ingredients).where(ingredients: {id: ingredient.id})
  # end

  ## SQL that works
  # SELECT "recipes".* 
  # FROM "recipes" 
  # INNER JOIN "recipe_ingredients" 
  #   ON "recipes"."id" = "recipe_ingredients"."recipe_id" 
  # WHERE "recipe_ingredients"."ingredient_id" = ?
  #   AND "recipes"."user_id" = ? 
  # LIMIT ?  [["ingredient_id", 1], ["user_id", 1], ["LIMIT", 11]]




  # Writer for custom nested attributes
  # def ingredients_attributes=(ingredient_attributes)
  #   ingredient_attributes.values.each do |ing_attribute|
  #       ingredient = Ingredient.find_or_create_by(ing_attribute)
  #       # Returns all ingredients from db
  #       # self.ingredients << ingredient

  #       # Only returns this category (faster)
  #         if !self.ingredients.include?(ingredient)
  #           self.post_ingredients.build(:ingredient => ingredient)
  #         end 

  #   end
  # end

end
