class Listing < ApplicationRecord
  def self.permitted_params
    [:property_id, :description, :price, :minimum_down_payment, :furnished]
  end

  set_index_columns do |user|
    %i(property price furnished published_at) +
      (user&.admin? ? [:deleted_at] : [])
  end

  validates :price, :description, presence: true, if: :published?
  validates :property, presence: true
  validates :property_id,
            uniqueness: { conditions: -> { published } },
            if: :published?

  has_many :visits, inverse_of: :listing
  belongs_to :property
  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  money :price, allow_nil: true
  money :minimum_down_payment, allow_nil: true

  def to_s
    "#{price&.format} - #{property.title}"
  end

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

  defaction :publish, 'Publicar', ability: :idle?,
            errors: { :published? => 'já está publicado',
                      :deleted_at? => 'foi publicado e removido' } do
    update(published_at: Time.zone.now)
  end

  defaction :remove, 'Remover', ability: :published?,
            errors: { :deleted_at? => 'já está removido' } do
    update(deleted_at: Time.zone.now)
  end
end
