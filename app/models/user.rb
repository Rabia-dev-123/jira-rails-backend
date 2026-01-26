
class User < ApplicationRecord
    has_secure_password
    has_many :boards, dependent: :destroy
  has_many :tasks
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

enum :role, { user: 0, admin: 1 }
end
