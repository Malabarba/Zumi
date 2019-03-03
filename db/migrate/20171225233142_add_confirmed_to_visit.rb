# frozen_string_literal: true

class AddConfirmedToVisit < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :status, :string, null: false
    add_index :visits, :status
  end
end
