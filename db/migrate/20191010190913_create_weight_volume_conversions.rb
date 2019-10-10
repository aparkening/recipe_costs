class CreateWeightVolumeConversions < ActiveRecord::Migration[6.0]
  def change
    create_table :weight_volume_conversions do |t|
      t.belongs_to :ingredient, index: true, foreign_key: true
      t.float :weight_size
      t.string :weight_unit
      t.float :vol_size
      t.string :vol_unit

      t.timestamps
    end
  end
end
