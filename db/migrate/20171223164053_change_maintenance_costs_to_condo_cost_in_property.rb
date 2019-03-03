# frozen_string_literal: true

class ChangeMaintenanceCostsToCondoCostInProperty < ActiveRecord::Migration[5.1]
  def change
    rename_column :properties, :monthly_maintenance_costs_cents, :condo_cost_cents
  end
end
