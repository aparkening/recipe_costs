class RecipeIngredient < ApplicationRecord
  # Relationships
  belongs_to :recipe
  # belongs_to :ingredientable, polymorphic: true

  belongs_to :ingredient
  # belongs_to :user_ingredient_costs
end
