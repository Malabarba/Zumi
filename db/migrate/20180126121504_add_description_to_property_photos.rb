# frozen_string_literal: true

class AddDescriptionToPropertyPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :property_photos, :description, :string
  end
end
