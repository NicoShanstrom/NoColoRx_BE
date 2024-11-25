class SavedPrescriptionSerializer
  include JSONAPI::Serializer

  attributes :drug_name, :drug_dosage, :manufacturer, :ingredients

  belongs_to :user, serializer: UserSerializer
end
