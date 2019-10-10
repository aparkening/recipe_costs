class Recipe < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
end
