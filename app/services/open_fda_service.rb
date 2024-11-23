class OpenFdaService
  BASE_URL = 'https://api.fda.gov/drug'

  def initialize
    @conn = Faraday.new(url: BASE_URL) do |f|
      f.params['fda_api_key'] = Rails.application.credentials.open_fda[:fda_api_key]
      f.request :json
    end
  end

  def get_drug_info(drug_name, dosage)
    @conn.get('label.json', search: "openfda.brand_name:#{drug_name} AND dosage_form:#{dosage}")
    parse_response(response)
  end

  private

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parsing error: #{e.message}")
    { error: 'Failed to parse response from openFDA' }
  end
end