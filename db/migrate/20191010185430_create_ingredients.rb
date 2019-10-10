class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.float :cost
      t.float :cost_size
      t.string :cost_unit

      t.timestamps
    end
  end
end
