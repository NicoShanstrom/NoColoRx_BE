require 'rails_helper'

RSpec.describe "Api::V1::DrugsController", type: :request, vcr: true do
  describe "GET /api/v1/drugs" do
    let(:drug_name) { "Dextroamphetamine" }

    context "when the drug_name parameter is provided" do
      it "returns filtered results from the DrugService" do
        get "/api/v1/drugs", params: { drug_name: drug_name }

        expect(response).to have_http_status(:ok)
        results = JSON.parse(response.body)

        expect(results).to have_key("data")
        expect(results["data"]).to be_an(Array)

        # Ensure results match expected structure
        if results["data"].any?
          first_result = results["data"].first
          expect(first_result).to include("id", "type", "attributes")
          expect(first_result["attributes"]).to include(
            "fields", 
            "package_label_principal_display_panel", 
            "metadata"
          )
        end
      end

      it "returns an empty result set if no matches are found" do
        # Use a non-matching drug name to trigger empty results
        get "/api/v1/drugs", params: { drug_name: "NonexistentDrug" }

        expect(response).to have_http_status(:ok)
        results = JSON.parse(response.body)
        expect(results).to eq({ "data" => [] })
      end
    end

    context "when the drug_name parameter is missing" do
      it "returns a bad request status with an error message" do
        get "/api/v1/drugs"

        expect(response).to have_http_status(:bad_request)
        error_message = JSON.parse(response.body)["error"]
        expect(error_message).to eq("Please provide a valid drug_name")
      end
    end
  end
end
