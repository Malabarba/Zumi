class SaleListing < PropertyListing
  validates :furnished, :price_cents, :description,
            presence: true, if: :published?
  validates :property_id, uniqueness: { conditions: -> { published } }

  def self.permitted_params
    [:property_id, :description, :price_cents, :minimum_down_payment_cents, :furnished]
  end

  INDEX_COLUMNS = {
    admin: [:property, :price_cents, :furnished, :published_at, :deleted_at].freeze
  }.freeze
end
