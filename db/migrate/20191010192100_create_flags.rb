class CreateFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :flags do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :ingredient, index: true, foreign_key: true
      t.string :note

      t.timestamps
    end
  end
end
