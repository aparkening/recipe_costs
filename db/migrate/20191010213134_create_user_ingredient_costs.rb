class CreateUserIngredientCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_ingredient_costs do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :ingredient, index: true, foreign_key: true
      t.float :cost
      t.float :cost_size
      t.string :cost_unit

      t.timestamps
    end
  end
end
