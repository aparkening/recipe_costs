class Ingredient < ApplicationRecord
  # Relationships
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  has_many :flags
end
