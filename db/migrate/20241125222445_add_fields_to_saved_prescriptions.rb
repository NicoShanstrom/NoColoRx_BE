class AddFieldsToSavedPrescriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :saved_prescriptions, :package_label_principal_display_panel, :text
    add_column :saved_prescriptions, :metadata, :jsonb
    add_column :saved_prescriptions, :fields, :jsonb
  end
end
