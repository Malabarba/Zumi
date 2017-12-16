class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :zip_code
      t.string :city
      t.string :state

      t.timestamps
    end
    add_index :addresses, :street
    add_index :addresses, :neighborhood
    add_index :addresses, :city
    add_index :addresses, :state
  end
end
