class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_RAGEX = /\A[\w+\-.]+@[a-z\d\.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with:  VALID_EMAIL_RAGEX }, uniqueness: true

  has_secure_password
end
