class Visit < ApplicationRecord
  def self.permitted_params
    %i(listing_id buyer_id visitor_id at)
  end

  set_index_columns do |user|
    if user&.admin?
      %i(buyer visitor at status)
    else
      %i(at status)
    end
  end

  include FilterableEnumerize

  belongs_to :listing, inverse_of: :visits
  belongs_to :buyer, class_name: 'User', inverse_of: :buy_visits
  belongs_to :visitor, optional: true, class_name: 'User', inverse_of: :sale_visits

  validates :listing, :buyer, :at, presence: true
  validate :availability

  enumerize :status, in: %i(pending confirmed canceled bailed), default: :pending

  private

  def availability
    return unless buyer && listing && at
    return add_error(:at, 'apenas a partir de amanhã') if at.to_date < Time.zone.tomorrow
    return add_error(:root, 'Você já tem um agendamento nesse horário') unless buyer.available?(at: at)
    return add_error(:root, 'Imóvel indisponível nesse horário') unless listing.available?(at: at)
  end
end
