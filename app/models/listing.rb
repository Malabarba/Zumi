# frozen_string_literal: true

class Listing < ApplicationRecord
  permit_params do
    next unless create?

    permit %i[description price minimum_down_payment furnished]
    permit %i[property_id] if admin?
  end

  admin_index_columns do
    %i[property price furnished published_at deleted_at]
  end

  serialize_with(:id, :uniq_hash, :property, :price_cents, :furnished,
                 :published_at, :deleted_at)

  before_create :assign_uniq_hash, :publish!

  validates :price, :description, presence: true
  validates :property, presence: true
  validates :property_id,
            uniqueness: { conditions: -> { published? } },
            if: :published?

  has_many :visits, inverse_of: :listing
  has_many :user_favorite_listings, inverse_of: :listing
  has_many :favorited_by, through: :user_favorite_listings, source: :user

  belongs_to :property
  scope :published, -> { where(deleted_at: nil).where.not(published_at: nil) }

  %i[toilet_count bath_count bedroom_count lot_size_m2 usable_size_m2].each do |f|
    ransack_alias f, :"property_#{f}"
  end
  ransack_alias :neighborhood, :property_address_neighborhood

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

  defaction :publish, 'Publicar', user_ability: is_owner,
                                  unless: { idle?: 'já foi publicada' } do
    touch(:published_at)
  end

  defaction :remove, 'Remover', user_ability: is_owner,
                                unless: { published?: 'não está publicada' } do
    touch(:deleted_at)
  end
end
