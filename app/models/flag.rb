class Flag < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  # Validations
  validates :user_id, presence: true
  validates :ingredient_id, presence: true
  validates :note, presence: true
end
