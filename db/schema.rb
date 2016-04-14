# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160414222922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", force: :cascade do |t|
    t.integer  "board_id"
    t.integer  "row_index"
    t.integer  "column_index"
    t.boolean  "is_ship_field", default: false
    t.boolean  "is_uncovered",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "winner_id"
    t.integer  "current_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paused",            default: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "password",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "logged_in"
    t.integer  "playing_game_id"
  end

  add_index "players", ["name"], name: "index_players_on_name", unique: true, using: :btree

end
