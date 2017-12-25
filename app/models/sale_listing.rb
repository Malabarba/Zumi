class SaleListing < PropertyListing
  def self.permitted_params
    [:property_id, :description, :price, :minimum_down_payment, :furnished]
  end

  set_index_columns do |user|
    %i(property price furnished published_at) +
      (user&.admin? ? [:deleted_at] : [])
  end

  validates :price, :description, presence: true, if: :published?
  money :price, allow_nil: true
  money :minimum_down_payment, allow_nil: true

  defaction :publish, ability: :idle?,
            errors: { :published? => 'já está publicado',
                      :deleted_at? => 'foi publicado e removido' } do
    update(published_at: Time.zone.now)
  end

  defaction :remove, ability: :published?,
            errors: { :deleted_at? => 'já está removido' } do
    update(deleted_at: Time.zone.now)
  end

  defaction :schedule_visit, ability: :published?, params: [:buyer_id, :at] do |args|
    visits.create(**args)
  end
end
