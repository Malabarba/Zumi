class PropertyListing < ApplicationRecord
  self.abstract_class = true
  validates :property_id, presence: true

  belongs_to :property
  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  def published?
    published_at?
  end

  def deleted?
    deleted_at?
  end
end
