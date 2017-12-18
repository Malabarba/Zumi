class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # `type' is a very useful column name.
  self.inheritance_column = nil

  def permitted_params
    self.class.permitted_params
  end

  def param_key
    self.class.model_name.param_key
  end

  def self.defaction(action, errors: {}, ability: nil, &block)
    define_method("may_#{action}?") do
      may = ability ? instance_eval(&ability) : true
      return false unless may
      errors.each do |cond, error|
        next unless instance_eval(&cond)
        self.errors.add(:root, error)
        return false
      end
      true
    end

    define_method("#{action}!") do |*args|
      return false unless public_send("may_#{action}?")
      instance_exec(*args, &block)
    end
  end
end
