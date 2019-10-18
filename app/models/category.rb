class Category < ApplicationRecord
  # Relationships
  belongs_to :user, dependent: :destroy
  has_many :category_recipes
  has_many :recipes, through: :category_recipes

  # Validations
  validates :name, presence: true
end
