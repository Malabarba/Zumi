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

  def may?(action)
    instance_exec(&self.class.actions[action][:ability])
  end

  class << self
    def actions
      @actions || {}
    end

    def defaction(action, label, errors: {}, ability: nil, params: [], &block)
      may = proc do
        next false unless ability.nil? || instance_eval(&ability)
        errors.each do |cond, error|
          next unless instance_eval(&cond)
          self.errors.add(:base, error)
          break
        end
        self.errors.blank?
      end

      @actions ||= {}
      @actions[action] = { params: params, ability: may, action: action, label: label }.freeze

      define_method("#{action}!") do |*args|
        next false unless may?(action)
        instance_exec(*args, &block)
      end
    end
  end
end
