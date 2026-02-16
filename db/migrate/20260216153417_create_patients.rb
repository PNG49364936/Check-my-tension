class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :nom
      t.string :prenom

      t.timestamps
    end
  end
end
