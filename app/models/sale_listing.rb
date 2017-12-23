class SaleListing < PropertyListing
  validates :price, :description, presence: true, if: :published?
  money :price, allow_nil: true
  money :minimum_down_payment, allow_nil: true

  def self.permitted_params
    [:property_id, :description, :price, :minimum_down_payment, :furnished]
  end

  INDEX_COLUMNS = {
    admin: [:property, :price, :furnished, :published_at, :deleted_at].freeze
  }.freeze
end
