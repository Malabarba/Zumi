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
end
