class Recipe < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  #### Add scope for returning user recipes by ingredient

  def my_ingredients
    #merge recipe ingredient and ingredients
  end

  # Writer for custom nested attributes
  # def ingredients_attributes=(ingredient_attributes)
  #   ingredient_attributes.values.each do |ing_attribute|
  #       ingredient = Ingredient.find_or_create_by(ing_attribute)
  #       # Returns all ingredients from db
  #       # self.ingredients << ingredient

  #       # Only returns this category (faster)
  #         if !self.ingredients.include?(ingredient)
  #           self.post_ingredients.build(:ingredient => ingredient)
  #         end 

  #   end
  # end

end
