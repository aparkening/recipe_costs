class WeightVolumeConversion < ApplicationRecord
  # Relationships
  belongs_to :ingredient, optional: true

  # Validations
  validates :ingredient_id, presence: true
  validates :weight_size, presence: true, numericality: true
  validates :weight_unit, presence: true
  validates :vol_size, presence: true, numericality: true
  validates :vol_unit, presence: true
end
