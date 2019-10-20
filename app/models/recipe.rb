class Recipe < ApplicationRecord
  require 'csv'
  # attr_accessor :total_cost, :per_serving_cost
  # attr_reader :recipe_cost

  # Relationships
  belongs_to :user
  has_many :category_recipes
  has_many :categories, through: :category_recipes
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  accepts_nested_attributes_for :recipe_ingredients, reject_if: proc { |attributes| attributes['ingredient_id'].blank? || attributes['ingredient_amount'].blank? || attributes['ingredient_unit'].blank?}, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { 
    scope: %i[user_id],
    message: 'must be unique.' 
  }

  # Scope to return user's recipes
  scope :users_recipes, -> (user) {where(user_id: user.id)}
    # call with Recipe.users_recipes(user)
  
  # Scope to return user's recipes by ingredient
  scope :recipes_of_ingredient, -> (ingredient) { joins(:ingredients).where(ingredients: {id: ingredient.id}) }
    # call with Recipe.recipes_of_ingredient(ingredient)
  

  # Class import method for CSVs 
  def self.import(file, user)
    # Create hash by looping through each row
    CSV.foreach(file.path, headers: true) do |row|
      # Specify fields
      recipe_name = row["recipe_name"]
      name = row["ingredient"]
      ingredient_amount = row["ingredient_amount"]
      ingredient_unit = row["ingredient_unit"]

      # Create record
      recipe = Recipe.find_by_name(recipe_name)
      if !recipe
        recipe = user.recipes.create(name: recipe_name)
      end

      recipe.recipe_ingredients.create(ingredient: Ingredient.find_by_name(name), ingredient_amount: ingredient_amount, ingredient_unit: ingredient_unit)

      recipe.save
    end
  end


    # Calculate recipe cost
    def recipe_cost
      recipe_total = 0
      self.recipe_ingredients.map do |ingredient|
        # Add cost to ingredient
        combo_ingredient = CombinedIngredient.new(ingredient)
  
        recipe_total += combo_ingredient.total_cost
      end
  
      # Add total cost to recipe
      total_cost = recipe_total.round(2)
  
      # # Add per serving cost to recipe
      # @per_serving_cost = (recipe_total/self.servings).round(2) if self.servings
        
      # binding.pry
    end

  # Determine recipe cost
  def self.recipes_costs(user)
    recipes = Recipe.users_recipes(user)
    recipe_total = 0

    recipes.each do |recipe|
      recipe.recipe_ingredients.each do |ingredient|
        # Add cost to ingredient
        combo_ingredient = CombinedIngredient.new(ingredient)

        recipe_total += combo_ingredient.total_cost
      end

      # Add total cost to recipe
      recipe.update(total_cost: recipe_total.round(2))
      recipe.save

      # # Add per serving cost to recipe
      # recipe.per_serving_cost = (recipe_total/self.servings).round(2) if self.servings

    end
  end


  # Writer for custom accepts_nested_attributes_for
  # def recipe_ingredients=(ingredients_attributes)

  #   ingredient = Ingredient.find(ingredients_attributes[:ingredient_id])

  #   if !self.recipe_ingredients.include?(ingredient)
  #     self.recipe_ingredients.build(:ingredient => ingredient, :ingredient_amount => ingredients_attributes[:ingredient_amount], :ingredient_unit => ingredients_attributes[:ingredient_unit])
  #   end 
  # end

end
