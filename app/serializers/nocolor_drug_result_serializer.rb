class NocolorDrugResultSerializer
  include JSONAPI::Serializer

  set_type :nocolor_drug_result
  attributes :fields, :package_label_principal_display_panel, :metadata
end
