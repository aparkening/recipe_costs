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
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, on: :create
  validates :email, uniqueness: true, allow_blank: true

  # Find or create user by Omniauth
  def self.find_or_create_by_omniauth(auth)

    # Creates a new user only if it doesn't exist
    where(uid: auth.uid).first_or_initialize do |user|
      user.uid ||= auth.uid
      user.name = auth.info.name
      user.email = auth.info.email

      if !user.password_digest
        pass = SecureRandom.hex(30)
        user.password = pass
        user.password_confirmation = pass
      end

      user.save
    end
  end

end
