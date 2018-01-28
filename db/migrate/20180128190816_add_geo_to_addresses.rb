class AddGeoToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :lat, :float
    add_column :addresses, :lng, :float
  end
end
