# frozen_string_literal: true

class AddOwnerToProperty < ActiveRecord::Migration[5.1]
  def change
    add_reference :properties, :user, foreign_key: true, index: true, null: false
  end
end
