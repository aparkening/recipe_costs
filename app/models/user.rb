class User < ApplicationRecord
  has_secure_password

  # Relationships
  has_many :categories
  has_many :recipes
  has_many :flags
  has_many :user_ingredient_costs
  has_many :ingredients, through: :user_ingredient_costs
  
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true, on: :create
  validates :password, length: { minimum: 6 }, confirmation: true, unless: ->(u){ u.password.blank? }
  validates :password_confirmation, presence: true, on: :create
end
