class CreateSaleListings < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_listings do |t|
      t.reference :property, null: false, index: true
      t.text :description
      t.integer :price_cents
      t.integer :minimum_down_payment_cents
      t.boolean :furnished
      t.datetime :published_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
