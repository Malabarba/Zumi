class PropertyListing < ApplicationRecord
  self.abstract_class = true
  validates :property, presence: true
  validates :property_id,
            uniqueness: { conditions: -> { published } },
            if: :published?

  has_many :visits, inverse_of: :sale_listing
  belongs_to :property
  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  def idle?
    !published_at?
  end

  def published?
    published_at? && !deleted?
  end

  def deleted?
    deleted_at?
  end

  def available?(at:)
    # TODO: Stub.
    true
  end
end
