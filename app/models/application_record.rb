require 'securerandom'

class ApplicationRecord < ActiveRecord::Base
  has_paper_trail

  self.abstract_class = true
  # `type' is a very useful column name.
  self.inheritance_column = nil

  def self.inherited(model)
    super
    hash = { model.model_name.param_key => { updated_at: 'Atualizado em', created_at: 'Criado em' } }
    I18n.backend.store_translations(:'pt-BR', {activerecord: {attributes: hash } })
  end

  def add_error(key, msg)
    errors.add(key, msg)
    false
  end

  def permitted_params
    self.class.permitted_params
  end

  def param_key
    self.class.model_name.param_key
  end

  include Serializable
  include Actionable

  class << self
    private

    def money(col, **opts)
      cents_col = :"#{col}_cents"
      monetize(cents_col, **opts)
      if col != cents_col && (name = human_attribute_name(col))
        hash = {activerecord: {attributes: {model_name.param_key => {cents_col => "#{name} (em centavos)"}}}}
        I18n.backend.store_translations(:'pt-BR', hash)
      end
    end

    def status_values(statii, default:)
      enumerize(:status, in: statii, default: default)
      delegate(*statii.map { |s| :"#{s}?" }, to: :status)
      statii.each { |s| scope(s, -> { where(status: s)}) }
    end
  end

  private

  def assign_uniq_hash
    while uniq_hash.blank? || self.class.find_by(uniq_hash: uniq_hash).present?
      self.uniq_hash = SecureRandom.urlsafe_base64
    end
  end
end
