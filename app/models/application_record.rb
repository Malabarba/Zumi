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

  def may?(action)
    instance_exec(&self.class.action_may[action])
  end

  class << self
    attr_reader :action_params
    attr_reader :action_may

    def defaction(action, errors: {}, ability: nil, params: [], &block)
      @action_params ||= {}
      @action_params[action] = params
      @action_may ||= {}
      @action_may[action] = proc do
        next false unless ability.nil? || instance_eval(&ability)
        errors.each do |cond, error|
          next unless instance_eval(&cond)
          self.errors.add(:root, error)
          break false
        end
        true
      end

      define_method("#{action}!") do |*args|
        next false unless may?(action)
        instance_exec(*args, &block)
      end
    end
  end
end
