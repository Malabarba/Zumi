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

  defaction :publish, ability: -> { !published? },
            errors: { :published? => 'já está publicado',
                      :deleted_at? => 'foi publicado e removido' } do
    update(published_at: Time.zone.now)
  end

  defaction :remove, ability: :published?,
            errors: { :deleted_at? => 'já está removido' } do
    update(deleted_at: Time.zone.now)
  end
end
