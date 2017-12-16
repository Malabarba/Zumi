sudo su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
sudo systemctl start postgresql.service

rails new . --git --database=postgresql
# Add   username: postgres to config/database.yml
rails db:create
rails generate model Address street:string:index number:string complement:string neighborhood:string:index zip_code:string city:string:index state:string:index
rails generate model Property address:reference:uniq type:string amenities:json lot_size_m2:integer usable_size_m2:integer monthly_maintenance_costs_cents:integer toilet_count:integer:index bath_count:integer:index bedroom_count:integer:index age_in_years:integer floor:integer building_height:integer

