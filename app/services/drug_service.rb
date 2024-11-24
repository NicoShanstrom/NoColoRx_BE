class DrugService
  def initialize(drug_name)
    @drug_name = drug_name.downcase
    @food_colorings = load_food_colorings
  end

  def fetch_drugs
    response = Faraday.get("https://api.fda.gov/drug/label.json") do |req|
      req.params['api_key'] = Rails.application.credentials.open_fda[:api_key]
      req.params['search'] = "openfda.generic_name:\"#{@drug_name}\""
      req.params['limit'] = 100
    end

    JSON.parse(response.body, symbolize_names: true)[:results] || []
  rescue JSON::ParserError
    []
  end

  def filter_results
    fetch_drugs.reject do |drug|
      fields_to_check = collect_fields(drug)
      fields_to_check.any? { |field| contains_food_coloring?(field) }
    end
  end

  def format_results
    filter_results.map do |drug|
      {
        fields: collect_fields(drug),
        package_label_principal_display_panel: drug[:package_label_principal_display_panel],
        metadata: {
          set_id: drug[:set_id],
          id: drug[:id],
          effective_time: drug[:effective_time],
          version: drug[:version],
          openfda: drug[:openfda]&.slice(
            :application_number,
            :brand_name,
            :generic_name,
            :manufacturer_name,
            :product_ndc,
            :product_type,
            :route,
            :substance_name,
            :rxcui,
            :spl_id,
            :spl_set_id,
            :package_ndc,
            :is_original_packager,
            :upc,
            :unii
          )
        }
      }
    end
  end

  private

  def collect_fields(drug)
    [
      drug[:description],
      drug[:inactive_ingredient],
      drug[:spl_product_data_elements],
      drug[:spl_unclassified_section],
      drug[:description_table],
      drug.dig(:openfda, :brand_name)
    ].flatten.compact.map { |field| normalize_field(field) }
  end

  def contains_food_coloring?(field)
    return false unless field.is_a?(String)

    @food_colorings.any? do |coloring|
      field.match?(/\b#{Regexp.escape(coloring)}\b/i)
    end
  end

  def normalize_field(field)
    field.to_s.gsub(/\s+/, ' ').strip.downcase
  end

  def load_food_colorings
    YAML.load_file(Rails.root.join('config', 'data', 'food_colorings.yml'))['food_colorings'].map(&:downcase)
  end
end
