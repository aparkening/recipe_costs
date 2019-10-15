class Flag < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :ingredient

  validates :note, presence: true
end
