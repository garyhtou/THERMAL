# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_09_095111) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "importer_google_drive_folders", force: :cascade do |t|
    t.string "drive_url", null: false
    t.string "drive_file_id", null: false
    t.bigint "user_id", null: false
    t.string "google_drive_channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_drive_channel_id"], name: "index_importer_google_drive_folders_on_google_drive_channel_id", unique: true
    t.index ["user_id", "drive_file_id"], name: "idx_on_user_id_drive_file_id_e8f3c3cf8b", unique: true
    t.index ["user_id"], name: "index_importer_google_drive_folders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "provider"
    t.string "provider_uid"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider_refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "provider_uid"], name: "index_users_on_provider_and_provider_uid", unique: true
  end

  add_foreign_key "importer_google_drive_folders", "users"
end
