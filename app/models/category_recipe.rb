class CategoryRecipe < ActiveRecord::Base
  # Relationships
  belongs_to :category
  belongs_to :recipe

  # Validations
  validates :category_id, presence: true
  validates :recipe_id, presence: true
end
