class RemoveUnusedColumnsFromSavedPrescriptions < ActiveRecord::Migration[8.0]
  def change
    remove_column :saved_prescriptions, :drug_dosage, :string
    remove_column :saved_prescriptions, :ingredients, :string
  end
end
