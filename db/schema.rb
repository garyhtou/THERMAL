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

ActiveRecord::Schema[8.0].define(version: 2024_11_11_224550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "importer_google_drive_files", force: :cascade do |t|
    t.string "drive_file_id", null: false
    t.string "name", null: false
    t.bigint "importer_google_drive_folder_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drive_file_id", "importer_google_drive_folder_id"], name: "idx_on_drive_file_id_importer_google_drive_folder_i_2904761520", unique: true
    t.index ["importer_google_drive_folder_id"], name: "idx_on_importer_google_drive_folder_id_4bee4a19c0"
    t.index ["user_id"], name: "index_importer_google_drive_files_on_user_id"
  end

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

  create_table "receipts", force: :cascade do |t|
    t.string "name", null: false
    t.string "body"
    t.bigint "user_id", null: false
    t.string "provenance_type", null: false
    t.bigint "provenance_id", null: false
    t.datetime "analyzed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_receipts_on_discarded_at"
    t.index ["provenance_type", "provenance_id"], name: "index_receipts_on_provenance"
    t.index ["user_id"], name: "index_receipts_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "importer_google_drive_files", "importer_google_drive_folders"
  add_foreign_key "importer_google_drive_files", "users"
  add_foreign_key "importer_google_drive_folders", "users"
  add_foreign_key "receipts", "users"
end
