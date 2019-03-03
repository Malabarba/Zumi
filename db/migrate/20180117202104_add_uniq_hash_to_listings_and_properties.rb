# frozen_string_literal: true

class AddUniqHashToListingsAndProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :uniq_hash, :string, null: false
    add_index :properties, :uniq_hash, unique: true
    add_column :listings, :uniq_hash, :string, null: false
    add_index :listings, :uniq_hash, unique: true
  end
end
