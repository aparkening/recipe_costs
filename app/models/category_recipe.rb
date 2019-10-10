class CategoryRecipe < ActiveRecord::Base
  # Relationships
  belongs_to :category
  belongs_to :recipe
end
