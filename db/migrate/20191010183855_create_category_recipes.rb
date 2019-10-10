class CreateCategoryRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :category_recipes do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :recipe, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
