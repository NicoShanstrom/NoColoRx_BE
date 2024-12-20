module FieldCollector
  def collect_fields(drug)
    [
      drug[:description],
      drug[:inactive_ingredient],
      drug[:spl_product_data_elements],
      drug[:spl_unclassified_section],
      drug[:description_table],
      drug.dig(:openfda, :brand_name)
    ].flatten.compact.map { |field| clean_field(field) }
  end

  private

  def clean_field(field)
    coder = HTMLEntities.new

    # Decode HTML entities, normalize case, strip tags, and whitespace
    normalized = coder.decode(field.to_s)
                      .gsub(/\s+/, ' ')             # Normalize whitespace
                      .gsub(/&/, 'and')             # Replace "&" with "and"
                      .strip                        # Remove leading/trailing spaces

    ActionController::Base.helpers.strip_tags(normalized).downcase
  end
end
