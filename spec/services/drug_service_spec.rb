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
      expect(formatted_results).to all(include(:fields, :package_label_principal_display_panel, :metadata))
      expect(formatted_results.first[:metadata]).to include(:set_id, :id, :effective_time, :version, :openfda)
      expect(formatted_results.first[:metadata][:openfda]).to include(:application_number, :brand_name, :manufacturer_name)
    end
  end
end
