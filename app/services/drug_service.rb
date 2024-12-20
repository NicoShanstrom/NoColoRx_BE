class DrugService
  include FieldCollector

  attr_reader :total_results

  def initialize(drug_name)
    @drug_name = drug_name.downcase
    @food_colorings = load_food_colorings
    # @total_results = 0 #initialize total results starting at 0
  end

  def fetch_drugs
    response = Faraday.get("https://api.fda.gov/drug/label.json") do |req|
      req.params['api_key'] = Rails.application.credentials.open_fda[:api_key]
      req.params['search'] = "openfda.generic_name:\"#{@drug_name}\""
      req.params['limit'] = 1000
    end
    response_body = JSON.parse(response.body, symbolize_names: true)
    @total_results = response_body.dig(:meta, :results, :total) || 0
    Rails.logger.debug "Fetched Total Results: #{@total_results}"
    # Rails.logger.debug "API Response Body: #{response_body}"
    
    # Debug the specific meta field
    # meta_results = response_body[:meta] && response_body[:meta][:results]
    # Rails.logger.debug "Meta Results Section: #{meta_results}"
    
    # Get the total results count from the meta section
    # @total_results = meta_results ? meta_results[:total] || 0 : 0
    # Rails.logger.debug "Total Results from Meta: #{@total_results}"
    
    # Return the results array
    response_body[:results] || []
  rescue JSON::ParserError => e
    Rails.logger.error "JSON Parse Error: #{e.message}"
    @total_results = 0 # Ensure @total_results is still set
    []
  end

  def filter_results
    @filtered_results ||= fetch_drugs.reject { |drug| food_coloring_present?(drug) }
  end

  def format_results
    drugs = fetch_drugs
    total_results_count = @total_results
    filtered_results_count = filter_results.size

    Rails.logger.debug "Total Results: #{total_results_count}, Filtered Results: #{filtered_results_count}"

   {
      data: NocolorDrugResultSerializer.new(filter_results.map { |drug| NocolorDrugResult.new(drug) }).serializable_hash[:data],
      meta: {
        total_results: total_results_count,
        filtered_results: filtered_results_count
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
