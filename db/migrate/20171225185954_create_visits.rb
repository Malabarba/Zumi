class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.references :listing, foreign_key: true, null: false
      t.bigint :buyer_id, foreign_key: true, null: false, index: true
      t.bigint :visitor_id, foreign_key: true, null: false, index: true
      t.datetime :at, null: false

      t.timestamps
    end
    add_index :visits, :at
  end
end
