require 'rails_helper'

RSpec.describe "Api::V1::SavedPrescriptions", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password123") }

  before do
    post "/api/v1/login", params: { email: user.email, password: "password123" }
  end

  describe "POST /api/v1/saved_prescriptions" do
    it "creates a new saved prescription with detailed fields" do
      prescription_params = {
        drug_name: "Xelstrym",
        manufacturer: "Noven Therapeutics, LLC",
        package_label_principal_display_panel: "PRINCIPAL DISPLAY PANEL - NDC: 68968-0205-3",
        fields: ["description xelstrym (dextroamphetamine) transdermal system..."],
        metadata: {
          set_id: "0862f02a-72a8-41cc-8845-57cf4974bb6f",
          id: "e5900a68-2bd4-4c69-9caf-131164062979",
          effective_time: "20231027",
          version: "13",
          openfda: {
            application_number: ["NDA215401"],
            brand_name: ["XELSTRYM"],
            manufacturer_name: ["Noven Therapeutics, LLC"]
          }
        }
      }

      post "/api/v1/saved_prescriptions", params: { saved_prescription: prescription_params }
      expect(response).to have_http_status(:created)
      result = JSON.parse(response.body)["data"]["attributes"]
      expect(result["drug_name"]).to eq("Xelstrym")
    end
  end
end
