class SavedPrescriptionSerializer
  include JSONAPI::Serializer

  attributes :drug_name, :manufacturer, :description, :package_label_principal_display_panel

  attribute :metadata do |object|
    Rails.logger.debug "Serializing Metadata: #{object.metadata}"
    object.metadata.slice("set_id", "id", "effective_time", "version", "openfda")
  end

  belongs_to :user, serializer: UserSerializer
end
