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

ActiveRecord::Schema[8.0].define(version: 2026_02_18_042732) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_keys_on_token"
  end

  create_table "game_events", force: :cascade do |t|
    t.string "category"
    t.string "event_type"
    t.datetime "occurred_at"
    t.jsonb "metadata", default: {}, null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.index ["event_type"], name: "index_game_events_on_event_type"
    t.index ["metadata"], name: "index_game_events_on_metadata", using: :gin
    t.index ["player_id"], name: "index_game_events_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_players_on_external_id"
  end

  add_foreign_key "game_events", "players"
end
