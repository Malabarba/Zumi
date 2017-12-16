class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement, null: false
      t.string :neighborhood, null: false
      t.string :zip_code, null: false
      t.string :city, null: false
      t.string :state, null: false

      t.timestamps
    end
    add_index :addresses, :street
    add_index :addresses, :neighborhood
    add_index :addresses, :city
    add_index :addresses, :state
    add_index :addresses, [:number, :complement, :zip_code], unique: true
  end
end
