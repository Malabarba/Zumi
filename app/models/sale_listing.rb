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

  def publish!
    errors.add(:root, 'já está publicado') if published?
    errors.add(:root, 'foi publicado e removido') if deleted_at?
    return false if errors.present?
    update(published_at: Time.zone.now)
  end
end
