class RecipeIngredient < ApplicationRecord
  # Relationships
  belongs_to :recipe
  belongs_to :ingredient
  # belongs_to :user_ingredient_costs

  # Validations
  validates :ingredient_amount, presence: true, numericality: true
  validates :ingredient_unit, presence: true
end
