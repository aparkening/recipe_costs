class UserIngredientCost < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  # Validations
  validates :user_id, presence: true
  validates :ingredient_id, presence: true  
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true
end
