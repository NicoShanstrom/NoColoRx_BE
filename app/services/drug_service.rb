class DrugService
  include FieldCollector

  attr_reader :total_results

  def initialize(drug_name)
    @drug_name = drug_name.downcase
    @food_colorings = load_food_colorings
    @total_results = 0 #initialize total results starting at 0
  end

  def fetch_drugs
    response = Faraday.get("https://api.fda.gov/drug/label.json") do |req|
      req.params['api_key'] = Rails.application.credentials.open_fda[:api_key]
      req.params['search'] = "openfda.generic_name:\"#{@drug_name}\""
      req.params['limit'] = 1000
    end

    drugs = JSON.parse(response.body, symbolize_names: true)[:results] || []
    @total_results = drugs.size # capture total results before filtering
    drugs
  rescue JSON::ParserError
    []
  end

  def filter_results
    @filtered_results ||= fetch_drugs.reject { |drug| food_coloring_present?(drug) }
  end

  def format_results
   {
      data: NocolorDrugResultSerializer.new(filter_results.map { |drug| NocolorDrugResult.new(drug) }).serializable_hash[:data],
      meta: {
        total_results: @total_results,
        filtered_results: filter_results.size
      }
    }
  end

  private
  
  def load_food_colorings
    YAML.load_file(Rails.root.join('config', 'data', 'food_colorings.yml'))['food_colorings'].map(&:downcase)
  end

  def contains_food_coloring?(field)
    return false unless field.is_a?(String)

    normalized_field = clean_field(field)

    @food_colorings.any? do |coloring|
      # Match variations like "FD&C Red No. 40" and "fd&c red #40"
      regex_pattern = coloring.downcase.gsub(/[^a-z0-9]/, '.*?') # Flexible matching
      normalized_field.match?(/\b#{regex_pattern}\b/)
    end
  end

  def food_coloring_present?(drug)
    collect_fields(drug).any? { |field| contains_food_coloring?(field) }
  end
end
