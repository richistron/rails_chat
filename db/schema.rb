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

ActiveRecord::Schema[7.0].define(version: 2023_06_24_182340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "expiration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_keys_on_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "chat_channels", force: :cascade do |t|
    t.string "name", limit: 50
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.index ["name"], name: "index_chat_channels_on_name", unique: true
  end

  create_table "chat_messages", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "content", limit: 200
    t.bigint "chat_channel_id", null: false
    t.bigint "user_id", null: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_channel_id"], name: "index_chat_messages_on_chat_channel_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 30
    t.string "password_digest"
    t.boolean "is_admin", default: false
    t.boolean "archived", default: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "chat_messages", "chat_channels"
  add_foreign_key "chat_messages", "users"
end
