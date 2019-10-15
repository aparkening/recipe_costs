class Category < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :recipes, through: :category_recipes

  validates :name, presence: true
end
