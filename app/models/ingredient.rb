class Ingredient < ApplicationRecord
  require 'csv'
  attr_accessor :total_cost

  # Relationships
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :flags

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true


  # Class import method for CSVs 
  def self.import(file)
    # Create hash by looping through each row
    CSV.foreach(file.path, headers: true) do |row|
      Ingredient.create! row.to_hash
    end
  end


end
