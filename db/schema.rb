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

ActiveRecord::Schema.define(version: 2020_03_16_125307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternatives", force: :cascade do |t|
    t.integer "service_id"
    t.integer "alternative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hibps", force: :cascade do |t|
    t.string "name"
    t.string "date"
    t.string "records"
    t.string "data"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "pribots", force: :cascade do |t|
    t.bigint "service_id"
    t.string "slug"
    t.string "polarity"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_pribots_on_service_id"
  end

  create_table "privacymonitors", force: :cascade do |t|
    t.bigint "service_id"
    t.string "slug"
    t.integer "score"
    t.string "title"
    t.string "trend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_privacymonitors_on_service_id"
  end

  create_table "privacyscores", force: :cascade do |t|
    t.bigint "service_id"
    t.string "slug"
    t.string "classification"
    t.string "polarity"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_privacyscores_on_service_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "rating"
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "upvote"
    t.integer "downvote"
    t.index ["service_id"], name: "index_reviews_on_service_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "service_categories", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_service_categories_on_category_id"
    t.index ["service_id"], name: "index_service_categories_on_service_id"
  end

  create_table "service_hibps", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "hibp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hibp_id"], name: "index_service_hibps_on_hibp_id"
    t.index ["service_id"], name: "index_service_hibps_on_service_id"
  end

  create_table "service_tosdrs", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "tosdr_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_tosdrs_on_service_id"
    t.index ["tosdr_id"], name: "index_service_tosdrs_on_tosdr_id"
  end

  create_table "service_wikipedia", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "wikipedia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_wikipedia_on_service_id"
    t.index ["wikipedia_id"], name: "index_service_wikipedia_on_wikipedia_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "impressions_count"
    t.string "slug"
    t.string "lead"
    t.string "company_name"
    t.string "company_url"
    t.string "icon"
  end

  create_table "tosdrs", force: :cascade do |t|
    t.string "name"
    t.string "polarity"
    t.string "score"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_services", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_user_services_on_service_id"
    t.index ["user_id"], name: "index_user_services_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "my_pantherscore"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wikipedia", force: :cascade do |t|
    t.string "name"
    t.string "date"
    t.string "records"
    t.string "sector"
    t.string "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wikipedia_sources", force: :cascade do |t|
    t.bigint "wikipedia_id"
    t.string "name"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wikipedia_id"], name: "index_wikipedia_sources_on_wikipedia_id"
  end

  add_foreign_key "pribots", "services"
  add_foreign_key "privacymonitors", "services"
  add_foreign_key "privacyscores", "services"
  add_foreign_key "reviews", "services"
  add_foreign_key "reviews", "users"
  add_foreign_key "service_categories", "categories"
  add_foreign_key "service_categories", "services"
  add_foreign_key "service_hibps", "hibps"
  add_foreign_key "service_hibps", "services"
  add_foreign_key "service_tosdrs", "services"
  add_foreign_key "service_tosdrs", "tosdrs"
  add_foreign_key "service_wikipedia", "services"
  add_foreign_key "service_wikipedia", "wikipedia", column: "wikipedia_id"
  add_foreign_key "user_services", "services"
  add_foreign_key "user_services", "users"
  add_foreign_key "wikipedia_sources", "wikipedia", column: "wikipedia_id"
end
