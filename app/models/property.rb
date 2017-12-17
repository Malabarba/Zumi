class Property < ApplicationRecord
  has_many :sale_listings
  belongs_to :address

  accepts_nested_attributes_for :address

  def self.permitted_params
    [:type,
     :lot_size_m2,
     :usable_size_m2,
     :monthly_maintenance_costs_cents,
     :toilet_count,
     :bath_count,
     :bedroom_count,
     :age_in_years,
     :floor,
     :building_height,
     address_attributes: [:id, *Address.permitted_params]]
  end

  def title
    "Imóvel ##{id} - #{address&.to_s_short}"
  end
end
