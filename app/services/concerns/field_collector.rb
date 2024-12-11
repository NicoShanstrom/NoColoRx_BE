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
    # Strip HTML tags and normalize whitespace
    ActionController::Base.helpers.strip_tags(field.to_s).gsub(/\s+/, ' ').strip
  end
end
