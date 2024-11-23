FactoryBot.define do
  factory :saved_prescription do
    user { nil }
    drug_name { "MyString" }
    drug_dosage { "MyString" }
    manufacturer { "MyString" }
    ingredients { "MyText" }
  end
end
