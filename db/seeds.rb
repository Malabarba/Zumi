# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

module Seed
  BASE_ADDRESSES = [{ zip_code: '04546-070', street: 'Rua Uberabinha', number: '310', neighborhood: 'Vila Olímpia', city: 'São Paulo', state: 'SP' },
                    { zip_code: '08150-154', street: 'Rua Particular B', number: '360', neighborhood: 'Jardim Robru', city: 'São Paulo', state: 'SP' },
                    { zip_code: '04620-013', street: 'Rua Cristóvão Pereira', number: '735', neighborhood: 'Campo Belo', city: 'São Paulo', state: 'SP' },
                    { zip_code: '03877-110', street: 'Avenida Lagoa Mirim', number: '171', neighborhood: 'Vila Rio Branco', city: 'São Paulo', state: 'SP' },
                    { zip_code: '05206-170', street: 'Rua Tabuleiros de Valença', number: '320', neighborhood: 'Vila Inácio', city: 'São Paulo', state: 'SP' },
                    { zip_code: '03985-070', street: 'Rua Engenheiro Sá Freire', number: '142', neighborhood: 'Jardim Ângela (Zona Leste)', city: 'São Paulo', state: 'SP' },
                    { zip_code: '03560-180', street: 'Travessa Nardo do Monte', number: '312', neighborhood: 'Vila Nhocune', city: 'São Paulo', state: 'SP' },
                    { zip_code: '02542-070', street: 'Travessa Antônio Argenti', number: '350', neighborhood: 'Sítio do Mandaqui', city: 'São Paulo', state: 'SP' },
                    { zip_code: '04436-040', street: 'Rua Plácido Nunes Vieira', number: '985', neighborhood: 'Jardim Consórcio', city: 'São Paulo', state: 'SP' },
                    { zip_code: '05687-030', street: 'Rua Ramos de Almeida', number: '395', neighborhood: 'Real Parque', city: 'São Paulo', state: 'SP' },
                    { zip_code: '04566-062', street: 'Rua Califórnia', number: '1257', neighborhood: 'Lalal', city: 'São Paulo', state: 'SP' },
                    { zip_code: '03613-160', street: 'Rua Manoel dos Santos Valbano', number: '100', neighborhood: 'Vila Santana', city: 'São Paulo', state: 'SP' }].freeze
  def self.address_attributes
    a = BASE_ADDRESSES.sample
    a.merge(complement: (rand * 10000).to_i, number: (a[:number].to_i * rand).to_i)
  end

  def self.[](a, b)
    if a.is_a?(Integer) && b.is_a?(Integer)
      (a..b).to_a.sample
    end
  end

  PHOTOS = Dir["#{Rails.root}/fixtures/photos/*"].map { |f| File.new(f) }.freeze
  def self.photo
    PHOTOS.sample
  end
end

if Rails.env.development? || Rails.env.staging?
  admin = User.find_by(email: 'admin@example.com') || User.new(email: 'admin@example.com')
  admin.update!(password: 'password', roles: [:admin], name: 'Administrador Responsável')
  buyer = User.find_by(email: 'buyer@example.com') || User.new(email: 'buyer@example.com')
  buyer.update!(password: 'password', roles: [:seller], name: 'Comprador Interessado')
  100.times do
    name = Faker::Simpsons.character
    seller = User.create!(password: 'password', roles: [:buyer], name: name,
                          email: "#{name.downcase.gsub(/\W+/, '.')}+#{(rand * 1000000).to_i}@example.com")
    begin
      seller.properties
            .create(address_attributes: Seed.address_attributes,
                    type: Property.type.values.sample,
                    condo_cost_cents: (rand * 7).to_i * 300,
                    lot_size_m2: Seed[40, 260],
                    usable_size_m2: Seed[40, 260],
                    toilet_count: Seed[1, 4],
                    bath_count: Seed[1, 4],
                    bedroom_count: Seed[1, 4],
                    age_in_years: Seed[1, 40],
                    floor: Seed[1, 20],
                    building_height: 20)
            .tap { |p| Seed[3, 10].times { p.photos.create(file: Seed.photo) } }
            .listings
            .create(description: Faker::Lorem.paragraph(3),
                    price_cents: Seed[4, 15] * 100_000_00,
                    minimum_down_payment_cents: [nil, 100_000_00, 300_000_00],
                    furnished: rand > 0.5,
                    published_at: Seed[1, 5].send(%i(days months years).sample).ago,
                    deleted_at: nil)
            .visits
            .tap { |v| v.create(at: Seed[1, 10].days.from_now + Seed[1, 10].hours,
                                buyer: buyer, visitor: admin) if rand > 0.5 }
      seller.properties
            .create(address_attributes: Seed.address_attributes,
                    type: Property.type.values.sample,
                    condo_cost_cents: (rand * 7).to_i * 300,
                    lot_size_m2: Seed[40, 260],
                    usable_size_m2: Seed[40, 260],
                    toilet_count: Seed[1, 4],
                    bath_count: Seed[1, 4],
                    bedroom_count: Seed[1, 4],
                    age_in_years: Seed[1, 4],
                    floor: Seed[1, 20],
                    building_height: 20)
    end
  end
end
