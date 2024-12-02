class RenameFieldsToDescriptionInSavedPrescriptions < ActiveRecord::Migration[8.0]
  def change
    rename_column :saved_prescriptions, :fields, :description
  end
end
