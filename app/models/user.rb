class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :downcase_email

  has_many :saved_prescriptions, dependent: :destroy

  private

  def downcase_email
    email.downcase! if email.present?
  end
end
