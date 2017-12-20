class SaleListing < PropertyListing
  validates :price_cents, :description, presence: true, if: :published?

  def self.permitted_params
    [:property_id, :description, :price_cents, :minimum_down_payment_cents, :furnished]
  end

  INDEX_COLUMNS = {
    admin: [:property, :price_cents, :furnished, :published_at, :deleted_at].freeze
  }.freeze
end
