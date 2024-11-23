class SavedPrescription < ApplicationRecord
  belongs_to :user

  validates :drug_name, presence: true
  validates :drug_dosage, presence: true
  validates :manufacturer, presence: true
  validates :ingredients, presence: true

  # Serialize ingredients for easier storage and retrieval
  serialize :ingredients, Array
end
