class SavedPrescription < ApplicationRecord
  belongs_to :user

  validates :drug_name, presence: true
  validates :manufacturer, presence: true
  validates :fields, presence: true
  validates :package_label_principal_display_panel, presence: true
  validates :metadata, presence: true
end
