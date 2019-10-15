class RecipeIngredient < ApplicationRecord
  # Relationships
  belongs_to :recipe
  belongs_to :ingredient
  # belongs_to :user_ingredient_costs

  # Validations
  validates :recipe_id, presence: true
  validates :ingredient_id, presence: true
  validates :ingredient_amount, presence: true, numericality: true
  validates :ingredient_unit, presence: true
end
