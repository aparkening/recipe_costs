class Flag < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  # Validations
  validates :note, presence: true
end
