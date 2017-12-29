class Property < ApplicationRecord
  def self.permitted_params
    [:owner_id,
     :type,
     :lot_size_m2,
     :usable_size_m2,
     :condo_cost,
     :toilet_count,
     :bath_count,
     :bedroom_count,
     :age_in_years,
     :floor,
     :building_height,
     address_attributes: [:id, *Address.permitted_params]]
  end

  set_index_columns do
    %i(address type toilet_count bath_count bedroom_count floor)
  end

  include FilterableEnumerize

  has_many :listings, inverse_of: :property
  has_many :photos, class_name: 'PropertyPhoto', inverse_of: :property
  belongs_to :address
  belongs_to :owner, class_name: 'User', inverse_of: :properties

  validates :address, :type, :toilet_count, :bath_count, :bedroom_count, :floor,
            presence: true
  money :condo_cost, allow_nil: true
  enumerize :type, in: %i(studio apartment house lot)

  accepts_nested_attributes_for :address

  def title
    "Imóvel ##{id} - #{address&.to_s_short}"
  end
end
