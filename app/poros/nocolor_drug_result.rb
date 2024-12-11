class NocolorDrugResult
  include FieldCollector

  attr_reader :drug

  def initialize(drug)
    @drug = drug
  end

  def id
    drug[:id]
  end

  def fields
    collect_fields(drug)
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
end