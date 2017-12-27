# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
module Seed
  def self.address_attributes
    { street: 'Rua Califórnia',
      number: '1257',
      complement: (rand * 10000).to_i,
      neighborhood: 'Lalal',
      zip_code: '04566-062',
      city: 'São Paulo',
      state: 'SP' }
  end
end

if Rails.env.development? || Rails.env.staging?
  admin = User.find_by(email: 'admin@example.com') || User.new(email: 'admin@example.com')
  admin.update!(password: 'password', roles: [:admin], name: 'Administrador Responsável')
  buyer = User.find_by(email: 'buyer@example.com') || User.new(email: 'buyer@example.com')
  buyer.update!(password: 'password', roles: [:seller], name: 'Comprador Interessado')
  seller = User.find_by(email: 'seller@example.com') || User.new(email: 'seller@example.com')
  seller.update!(password: 'password', roles: [:buyer], name: 'Vendedor Entusiasmado')
  begin
    seller.properties
          .create(address_attributes: Seed.address_attributes,
                  type: :apartment,
                  lot_size_m2: 1,
                  usable_size_m2: 1,
                  condo_cost_cents: 20000,
                  toilet_count: 2,
                  bath_count: 2,
                  bedroom_count: 2,
                  age_in_years: 2,
                  floor: 2,
                  building_height: 2,
                  owner_id: 1)
          .listings
          .create(description: "asdok oaksda odkaso ",
                  price_cents: 30000000,
                  minimum_down_payment_cents: nil,
                  furnished: true,
                  published_at: Time.zone.now,
                  deleted_at: nil)
          .visits
          .create(at: 1.day.from_now, buyer: buyer, visitor: admin)
  end
end
