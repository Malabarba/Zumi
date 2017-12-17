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
end
