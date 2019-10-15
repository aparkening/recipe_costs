class Ingredient < ApplicationRecord
  # Relationships
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  has_many :flags

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true
end
