class Visit < ApplicationRecord
  def self.permitted_params
    %i(listing_id buyer_id visitor_id at)
  end

  admin_index_columns do
    %i(at status_text buyer_phone buyer visitor)
  end

  serialize_with(:at, :status)

  include FilterableEnumerize

  belongs_to :listing, inverse_of: :visits
  belongs_to :buyer, class_name: 'User', inverse_of: :buy_visits
  belongs_to :visitor, optional: true, class_name: 'User', inverse_of: :sale_visits

  validates :listing, :buyer, :at, presence: true
  validate :availability

  status_values %i(pending confirmed canceled bailed), default: :pending
  scope :to_go, -> { confirmed.where('at::date >= ?', Time.zone.today) }

  defaction :confirm, 'Confirmar', user_ability: :admin,
            if: { :confirmed? => 'já está confirmada'} do
    update(status: :confirmed)
  end

  defaction :cancel, 'Cancelar', user_ability: :admin,
            if: { :canceled? => 'já está cancelada',
                  :bailed? => 'já está confirmada' } do
    update(status: :canceled)
  end

  defaction :bailed, 'Comprador Deu Bolo', user_ability: :admin,
            unless: { :confirmed? => 'não está confirmada' },
            if: { :future? => 'ainda não passou' } do
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
