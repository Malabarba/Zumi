class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.references :address, null: false, index: :uniq
      t.string :type, null: false, index: true
      t.integer :lot_size_m2
      t.integer :usable_size_m2
      t.integer :monthly_maintenance_costs_cents
      t.integer :toilet_count
      t.integer :bath_count
      t.integer :bedroom_count
      t.integer :age_in_years
      t.integer :floor
      t.integer :building_height

      t.timestamps
    end
    add_index :properties, :toilet_count
    add_index :properties, :bath_count
    add_index :properties, :bedroom_count
  end
end
