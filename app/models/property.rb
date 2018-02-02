class Property < ApplicationRecord
  permit_params do
    permit %i(owner_id) if admin? && create?
    permit %i(type lot_size_m2 usable_size_m2 condo_cost age_in_years)
    permit %i(floor building_height toilet_count bath_count bedroom_count)
    permit [address_attributes: [:id, *Address.permitted_params]]
  end

  admin_index_columns do
    %i(address type_text toilet_count bath_count bedroom_count floor)
  end

  serialize_with(:id, :uniq_hash, :address, :photos, :type, :type_text,
                 :toilet_count, :bath_count, :bedroom_count,
                 :lot_size_m2, :usable_size_m2,
                 :condo_cost_cents, :floor,
                 :current_listing)

  include FilterableEnumerize

  has_one :current_listing, -> { published }, class_name: 'Listing'
  has_many :listings, inverse_of: :property
  has_many :favorited_by, through: :listings
  has_many :photos, class_name: 'PropertyPhoto', inverse_of: :property
  belongs_to :address
  belongs_to :owner, class_name: 'User', inverse_of: :properties

  before_create :assign_uniq_hash
  validates :address, :type, :toilet_count, :bath_count, :bedroom_count, :floor,
            presence: true

  money :condo_cost, allow_nil: true
  enumerize :type, in: %i(studio apartment house lot)

  accepts_nested_attributes_for :address

  def title
    "Imóvel ##{id} - #{address&.to_s_short}"
  end
end
