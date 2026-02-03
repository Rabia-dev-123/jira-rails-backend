class User < ApplicationRecord
  has_secure_password

  has_many :boards, dependent: :destroy
  has_many :tasks

  # Email validation
  validates :email, presence: true, uniqueness: true

  # Username validation (8 to 20 characters)
  validates :name, presence: true, length: { minimum: 8, maximum: 20 }

  # Password validation (8 to 20 characters)
  validates :password, length: { minimum: 8, maximum: 20 }, if: :password_present?

  enum :role, { user: 0, admin: 1 }

  private

  def password_present?
    password.present?
  end
end
