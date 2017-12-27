class Visit < ApplicationRecord
  def self.permitted_params
    %i(listing_id buyer_id visitor_id at)
  end

  set_index_columns do |user|
    if user&.admin?
      %i(at status_text buyer_phone buyer visitor)
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

  status_values %i(pending confirmed canceled bailed), default: :pending
  scope :to_go, -> { confirmed.where('at::date >= ?', Time.zone.today) }

  defaction :confirm, 'Confirmar', ability: :pending? do
    update(status: :confirmed)
  end

  defaction :cancel, 'Cancelar',
            ability: proc { pending? || confirmed? } do
    update(status: :canceled)
  end

  defaction :bailed, 'Comprador Deu Bolo',
            errors: { :future? => 'Horário da visita ainda não passou' },
            ability: :confirmed? do
    update(status: :bailed)
  end

  delegate :past?, :future?, :today?, to: :at
  delegate :phone, to: :buyer, prefix: true

  private

  def availability
    return unless buyer && listing && at
    return add_error(:at, 'apenas a partir de amanhã') if at.to_date < Time.zone.tomorrow
    return add_error(:root, 'Você já tem um agendamento nesse horário') unless buyer.available?(at: at)
    return add_error(:root, 'Imóvel indisponível nesse horário') unless listing.available?(at: at)
  end
end
