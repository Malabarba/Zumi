# frozen_string_literal: true

class CreateUserFavoriteListings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_favorite_listings do |t|
      t.references :listing, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
