class Visit < ApplicationRecord
  def self.permitted_params
    %i(buyer visitor at)
  end

  set_index_columns do |user|
    if user&.admin?
      %i(buyer visitor at)
    else
      %i(at)
    end
  end

  belongs_to :sale_listing, inverse_of: :visits
  belongs_to :buyer, class_name: 'User', inverse_of: :buy_visits
  belongs_to :visitor, class_name: 'User', inverse_of: :sale_visits

  validates :sale_listing, :buyer, :at, presence: true
  validates :at, allow_blank: true, on_or_after: -> { Time.zone.now }
  validates :availability

  private

  def availability
    return unless buyer && sale_listing && at
    return add_error(:buyer, 'indisponível nesse horário') unless buyer.available?(at: at)
    return add_error(:sale_listing, 'indisponível nesse horário') unless sale_listing.available?(at: at)
  end
end
