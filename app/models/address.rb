class Address < ApplicationRecord
  validates :street, :number, :complement, :neighborhood, :zip_code, :city, :state,
            presence: true
end
