class Recipe < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  # accepts_nested_attributes_for :recipe_ingredients

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { 
    scope: %i[user_id],
    message: 'must be unique.' 
  }

  # Scope to return user's recipes
  scope :users_recipes, -> (user) {where(user_id: user.id)}
    # call with Recipe.users_recipes(user)
  
  # Scope to return user's recipes by ingredient
  scope :recipes_of_ingredient, -> (ingredient) { joins(:ingredients).where(ingredients: {id: ingredient.id}) }
    # call with Recipe.recipes_of_ingredient(ingredient)


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


  # Writer for custom accepts_nested_attributes_for
  def recipe_ingredients=(ingredients_attributes)
    # binding.pry
    ingredient = Ingredient.find(ingredients_attributes[:ingredient_id])

    if !self.recipe_ingredients.include?(ingredient)
      self.recipe_ingredients.build(:ingredient => ingredient, :ingredient_amount => ingredients_attributes[:ingredient_amount], :ingredient_unit => ingredients_attributes[:ingredient_unit])
    end 
  end

end
