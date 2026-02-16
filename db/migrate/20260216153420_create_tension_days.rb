class CreateTensionDays < ActiveRecord::Migration[7.1]
  def change
    create_table :tension_days do |t|
      t.references :patient, null: false, foreign_key: true
      t.date :observation_date
      t.integer :morning_systolic
      t.integer :morning_diastolic
      t.integer :evening_systolic
      t.integer :evening_diastolic

      t.timestamps
    end
  end
end
