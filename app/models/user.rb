class User < ApplicationRecord
  has_secure_password

  # Relationships
  has_many :categories
  has_many :recipes
  has_many :flags
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  
  # Validations
  validates :name, presence: true, uniqueness: true




end
