# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171216235405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "number", null: false
    t.string "complement", null: false
    t.string "neighborhood", null: false
    t.string "zip_code", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["neighborhood"], name: "index_addresses_on_neighborhood"
    t.index ["number", "complement", "zip_code"], name: "index_addresses_on_number_and_complement_and_zip_code", unique: true
    t.index ["state"], name: "index_addresses_on_state"
    t.index ["street"], name: "index_addresses_on_street"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.string "type", null: false
    t.integer "lot_size_m2"
    t.integer "usable_size_m2"
    t.integer "monthly_maintenance_costs_cents"
    t.integer "toilet_count"
    t.integer "bath_count"
    t.integer "bedroom_count"
    t.integer "age_in_years"
    t.integer "floor"
    t.integer "building_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_properties_on_address_id"
    t.index ["bath_count"], name: "index_properties_on_bath_count"
    t.index ["bedroom_count"], name: "index_properties_on_bedroom_count"
    t.index ["toilet_count"], name: "index_properties_on_toilet_count"
    t.index ["type"], name: "index_properties_on_type"
  end

  create_table "sale_listings", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.text "description"
    t.integer "price_cents"
    t.integer "minimum_down_payment_cents"
    t.boolean "furnished"
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_sale_listings_on_property_id"
  end

end
