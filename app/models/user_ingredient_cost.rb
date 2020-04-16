class UserIngredientCost < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  # Validations
  validates :ingredient_id, uniqueness: { scope: :user_id, message: "already exists. Only one custom cost allowed per ingredient." }
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true

end
