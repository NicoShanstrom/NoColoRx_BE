class CreateSavedPrescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_prescriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :drug_name
      t.string :drug_dosage
      t.string :manufacturer
      t.text :ingredients

      t.timestamps
    end
  end
end
