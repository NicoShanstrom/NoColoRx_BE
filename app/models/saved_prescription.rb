class SavedPrescription < ApplicationRecord
  belongs_to :user

  validates :drug_name, :manufacturer, :description, :package_label_principal_display_panel, presence: true
  validate :validate_metadata_format

  private

  def validate_metadata_format
    unless metadata.is_a?(Hash) && metadata["openfda"].is_a?(Hash)
      errors.add(:metadata, "must include a valid openfda object")
    end
  end
end
