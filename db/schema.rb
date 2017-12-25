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

ActiveRecord::Schema.define(version: 20171225220151) do

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

  create_table "listings", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.text "description"
    t.integer "price_cents"
    t.integer "minimum_down_payment_cents"
    t.boolean "furnished"
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_listings_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.string "type", null: false
    t.integer "lot_size_m2"
    t.integer "usable_size_m2"
    t.integer "condo_cost_cents"
    t.integer "toilet_count"
    t.integer "bath_count"
    t.integer "bedroom_count"
    t.integer "age_in_years"
    t.integer "floor"
    t.integer "building_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id", null: false
    t.index ["address_id"], name: "index_properties_on_address_id"
    t.index ["bath_count"], name: "index_properties_on_bath_count"
    t.index ["bedroom_count"], name: "index_properties_on_bedroom_count"
    t.index ["owner_id"], name: "index_properties_on_owner_id"
    t.index ["toilet_count"], name: "index_properties_on_toilet_count"
    t.index ["type"], name: "index_properties_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.string "first_name"
    t.string "surname"
    t.string "phone"
    t.date "birth_date"
    t.bigint "roles_mask"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.string "action"
    t.jsonb "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "visitor_id"
    t.datetime "at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["at"], name: "index_visits_on_at"
    t.index ["buyer_id"], name: "index_visits_on_buyer_id"
    t.index ["listing_id"], name: "index_visits_on_listing_id"
    t.index ["visitor_id"], name: "index_visits_on_visitor_id"
  end

  add_foreign_key "properties", "users", column: "owner_id"
  add_foreign_key "visits", "listings"
end
