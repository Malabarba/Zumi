class PropertyListing < ApplicationRecord
  self.abstract_class = true
  validates :property, presence: true
  validates :property_id,
            uniqueness: { conditions: -> { published } },
            if: :published?

  belongs_to :property
  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  def published?
    published_at?
  end

  def deleted?
    deleted_at?
  end
end
