class CreatePropertyPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :property_photos do |t|
      t.attachment :file
      t.references :property, foreign_key: true, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
