class SavedPrescription < ApplicationRecord
  belongs_to :user

  validates :drug_name, :manufacturer, :description, :package_label_principal_display_panel, :metadata, presence: true
  validate :validate_openfda

  private

  def validate_openfda
    Rails.logger.debug "Validating Metadata: #{metadata}"
    unless metadata.is_a?(Hash) && metadata["openfda"].is_a?(Hash)
      errors.add(:metadata, "must include an openfda hash")
    end
  end
end
