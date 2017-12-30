class ApplicationRecord < ActiveRecord::Base
  has_paper_trail

  self.abstract_class = true
  # `type' is a very useful column name.
  self.inheritance_column = nil

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

  def self.set_index_columns(&block)
    @index_columns_block = block
  end

  def self.index_columns(*args)
    @index_columns_block.call(*args)
  end

  def self.money(col, **opts)
    cents_col = :"#{col}_cents"
    monetize(cents_col, **opts)
    if col != cents_col && (name = human_attribute_name(col))
      hash = {activerecord: {attributes: {model_name.param_key => {cents_col => "#{name} (em centavos)"}}}}
      I18n.backend.store_translations(:'pt-BR', hash)
    end
  end

  def self.status_values(statii, default:)
    enumerize(:status, in: statii, default: default)
    delegate(*statii.map { |s| :"#{s}?" }, to: :status)
    statii.each { |s| scope(s, -> { where(status: s)}) }
  end

  def may?(action, **context)
    instance_exec(context, &self.class.actions[action][:ability])
  end

  class << self
    def actions
      @actions || {}
    end

    def defaction(action, label,
                  errors: {}, ability: nil, user_ability: nil,
                  params: [], admin: false, &block)
      may = proc do |context = {}|
        next false unless able?(ability, context)
        unless context[:user]&.admin?
          next false if admin || !able?(user_ability, context)
        end

        errors.each do |cond, error|
          next unless able?(cond, context)
          self.errors.add(:base, error)
          break
        end
        self.errors.blank?
      end

      @actions ||= {}
      @actions[action] = { params: params, ability: may, action: action, label: label }.freeze

      define_method("#{action}!") do |args:, **opts|
        next false unless may?(action, opts)
        instance_exec(*args, &block)
      end
    end
  end

  private

  def able?(ability, *args)
    case ability
    when nil then true
    when Symbol then instance_eval(&ability)
    else instance_exec(*args, &ability)
    end
  end
end
