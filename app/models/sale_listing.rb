class SaleListing < PropertyListing
  validates :price, :description, presence: true, if: :published?
  money :price, allow_nil: true
  money :minimum_down_payment, allow_nil: true

  def self.permitted_params
    [:property_id, :description, :price, :minimum_down_payment, :furnished]
  end

  def self.index_columns
    base = %i(property price furnished published_at)
    base << :deleted_at if current_user&.admin?
    base
  end
end
