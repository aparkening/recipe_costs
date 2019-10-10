class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.belongs_to :user
      t.string :name
      t.integer :servings

      t.timestamps
    end
  end
end
