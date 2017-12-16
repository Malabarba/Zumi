class Address < ApplicationRecord
  validate :street,
           :number,
           :complement,
           :neighborhood,
           :zip_code,
           :city,
           :state,
           presence: true
end
