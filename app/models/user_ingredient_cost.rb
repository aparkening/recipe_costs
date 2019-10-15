class UserIngredientCost < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  # Validations
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true
end
