class PropertyListing < ApplicationRecord
  self.abstract_class = true
  validate :property_id, presence: true

  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  alias published? published_at?
  alias deleted? deleted_at?
end
