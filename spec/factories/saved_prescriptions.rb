FactoryBot.define do
  factory :saved_prescription do
    user
    drug_name { "Aspirin" }
    drug_dosage { "100 mg" }
    manufacturer { "Pharma Co." }
    ingredients { ["Aspirin", "Inactive Ingredient"] }
  end
end
