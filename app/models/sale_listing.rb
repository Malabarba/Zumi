class SaleListing < PropertyListing
  validates :furnished, :price_cents, :description,
            presence: true, if: :published?

  def self.permitted_params
    [:property, :description, :price_cents, :minimum_down_payment_cents, :furnished]
  end
end
