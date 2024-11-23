class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  before_save { email.downcase! }

  has_many :saved_prescriptions, dependent: :destroy
end
