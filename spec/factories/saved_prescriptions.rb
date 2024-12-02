FactoryBot.define do
  factory :saved_prescription do
    user
    drug_name { "Aspirin" }
    manufacturer { "Pharma Co." }
    description { ["Aspirin", "Inactive Ingredient"] }
    package_label_principal_display_panel { "PRINCIPAL DISPLAY PANEL - NDC: 12345-6789-0" }
    metadata do
      {
        set_id: "12345-6789-0",
        id: "abcde-12345",
        effective_time: "20240101",
        version: "1"
      }
    end
  end
end
