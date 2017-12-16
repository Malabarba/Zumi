sudo su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
sudo systemctl start postgresql.service

rails new . --git --database=postgresql
# Add   username: postgres to config/database.yml
rails db:create
rails generate model Address street:string:index number:string complement:string neighborhood:string:index zip_code:string city:string:index state:string:index

