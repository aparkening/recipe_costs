class RecipeIngredient < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :recipe
  belongs_to :ingredient
end
