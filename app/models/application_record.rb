class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # `type' is a very useful column name.
  self.inheritance_column = nil
end
