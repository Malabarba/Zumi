# frozen_string_literal: true

class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cpf, :string
    add_column :users, :first_name, :string
    add_column :users, :surname, :string
    add_column :users, :phone, :string
    add_column :users, :birth_date, :date
    add_column :users, :roles_mask, :bigint
    add_index :users, :cpf, unique: true
  end
end
