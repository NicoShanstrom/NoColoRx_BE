class NocolorDrugResult
  attr_reader :drug

  def initialize(drug)
    @drug = drug
  end

  def id
    drug[:id]
  end

  def fields
    collect_fields
  end

  def package_label_principal_display_panel
    drug[:package_label_principal_display_panel]
  end

  def metadata
    {
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
  end

  private

  def collect_fields
    [
      drug[:description],
      drug[:inactive_ingredient],
      drug[:spl_product_data_elements],
      drug[:spl_unclassified_section],
      drug[:description_table],
      drug.dig(:openfda, :brand_name)
    ].flatten.compact.map { |field| normalize_field(field) }
  end

  def normalize_field(field)
    field.to_s.gsub(/\s+/, ' ').strip.downcase
  end
end
