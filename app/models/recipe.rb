class Recipe < ApplicationRecord
  require 'csv'

  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  # Accept recipe_ingredients nested attributes
  accepts_nested_attributes_for :recipe_ingredients, reject_if: proc { |attributes| attributes['ingredient_id'].blank? || attributes['ingredient_amount'].blank? || attributes['ingredient_unit'].blank?}, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { 
    scope: %i[user_id],
    message: 'must be unique.' 
  }

  # Return user's recipes
  scope :users_recipes, -> (user) {where(user_id: user.id)}
    # call with Recipe.users_recipes(user)
  
  # Return user's recipes by ingredient
  scope :recipes_of_ingredient, -> (ingredient) { joins(:ingredients).where(ingredients: {id: ingredient}) }

  # Return all user's ingredients used in recipes
  scope :all_ingredients, -> { joins(:ingredients).select("ingredients.*") }


  # CSV Import
  def self.import(file, user)
    # Create hash by looping through each row
    CSV.foreach(file.path, headers: true) do |row|
      # Specify fields
      recipe_name = row["recipe_name"]
      name = row["ingredient"]
      ingredient_amount = row["ingredient_amount"]
      ingredient_unit = row["ingredient_unit"]

      # Find or create recipe
      recipe = Recipe.find_by_name(recipe_name)
      if !recipe
        recipe = user.recipes.create(name: recipe_name)
      end

      # Create recipe_ingredient record
      recipe.recipe_ingredients.create(ingredient: Ingredient.find_by_name(name), ingredient_amount: ingredient_amount, ingredient_unit: ingredient_unit)

      recipe.save
    end
  end


 ## Instance versions 
    # Calculate recipe cost
    # def ingredient_costs
    #   recipe_total = 0
    #   self.recipe_ingredients.map do |ingredient|
    #     # Add cost to ingredient
    #     combo_ingredient = CombinedIngredient.new(ingredient).total_cost
    #     # recipe_total += combo_ingredient.total_cost
    #   end
    # end

    # Calculate total recipe cost
    def total_cost(ingredient_costs)
      ingredient_costs.inject(0){|sum,x| sum + x.total_cost }.round(2)
    end

    # Calculate recipe cost per serving
    def cost_per_serving(total_cost)
      (total_cost/self.servings).round(2)
    end


  # Writer for custom accepts_nested_attributes_for
  # def recipe_ingredients=(ingredients_attributes)

  #   ingredient = Ingredient.find(ingredients_attributes[:ingredient_id])

  #   if !self.recipe_ingredients.include?(ingredient)
  #     self.recipe_ingredients.build(:ingredient => ingredient, :ingredient_amount => ingredients_attributes[:ingredient_amount], :ingredient_unit => ingredients_attributes[:ingredient_unit])
  #   end 
  # end

end
