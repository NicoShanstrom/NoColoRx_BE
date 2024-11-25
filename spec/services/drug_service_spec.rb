require "rails_helper"

RSpec.describe DrugService, :vcr do
  let(:drug_name) { 'Dextroamphetamine' }
  let(:service) { described_class.new(drug_name) }

  describe '#filter_results' do
    it 'filters out drugs containing FD&C-related food colorings' do
      filtered_drugs = service.filter_results

      # Ensure no fields in the filtered drugs contain FD&C colors
      filtered_drugs.each do |drug|
        fields = service.send(:collect_fields, drug)
        fields.each do |field|
          expect(field).not_to match(/\bfd&c\b/i)
        end
      end
    end
  end

  describe '#format_results' do
    it 'formats the results with specified keys and fields' do
      formatted_results = service.format_results
      # Validate JSON:API-compliant structure
      expect(formatted_results).to include(:data)
      expect(formatted_results[:data]).to be_an(Array)

      first_result = formatted_results[:data].first
      expect(first_result).to include(:id, :type, :attributes)
      expect(first_result[:type]).to eq(:nocolor_drug_result)
      expect(first_result[:attributes]).to include(:fields, :package_label_principal_display_panel, :metadata)

      metadata = first_result[:attributes][:metadata]
      expect(metadata).to include(:set_id, :id, :effective_time, :version, :openfda)
      expect(metadata[:openfda]).to include(:application_number, :brand_name, :manufacturer_name)
    end
  end
end

RSpec.describe NocolorDrugResult do
  let(:drug_data) do
    {
      description: "Sample drug description",
      inactive_ingredient: ["Sugar", "FD&C Blue #2"],
      package_label_principal_display_panel: "Label Info",
      set_id: "abc123",
      id: "def456",
      effective_time: "20231015",
      version: "12",
      openfda: {
        application_number: ["NDA12345"],
        brand_name: ["TestBrand"],
        manufacturer_name: ["TestManufacturer"],
        product_ndc: ["12345-6789"],
        product_type: ["HUMAN PRESCRIPTION DRUG"]
      }
    }
  end

  let(:drug_result) { described_class.new(drug_data) }

  describe '#fields' do
    it 'returns the collected fields' do
      fields = drug_result.fields
      expect(fields).to include("sample drug description")
    end
  end

  describe '#metadata' do
    it 'returns metadata with specified keys' do
      metadata = drug_result.metadata
      expect(metadata).to include(:set_id, :id, :effective_time, :version, :openfda)
      expect(metadata[:openfda]).to include(:application_number, :brand_name, :manufacturer_name)
    end
  end

  describe '#package_label_principal_display_panel' do
    it 'returns the package label principal display panel' do
      expect(drug_result.package_label_principal_display_panel).to eq("Label Info")
    end
  end
end

RSpec.describe NocolorDrugResultSerializer do
  let(:drug_data) do
    {
      description: "Sample drug description",
      inactive_ingredient: ["Sugar", "FD&C Blue #2"],
      package_label_principal_display_panel: "Label Info",
      set_id: "abc123",
      id: "def456",
      effective_time: "20231015",
      version: "12",
      openfda: {
        application_number: ["NDA12345"],
        brand_name: ["TestBrand"],
        manufacturer_name: ["TestManufacturer"],
        product_ndc: ["12345-6789"],
        product_type: ["HUMAN PRESCRIPTION DRUG"]
      }
    }
  end

  let(:drug_result) { NocolorDrugResult.new(drug_data) }
  let(:serializer) { described_class.new(drug_result) }

  describe '#serializable_hash' do
    it 'serializes the drug result into JSON:API-compliant structure' do
      serialized_hash = serializer.serializable_hash

      expect(serialized_hash).to include(:data)
      expect(serialized_hash[:data]).to include(:id, :type, :attributes)

      attributes = serialized_hash[:data][:attributes]
      expect(attributes).to include(:fields, :package_label_principal_display_panel, :metadata)

      metadata = attributes[:metadata]
      expect(metadata).to include(:set_id, :id, :effective_time, :version, :openfda)
      expect(metadata[:openfda]).to include(:application_number, :brand_name, :manufacturer_name)
    end
  end
end
