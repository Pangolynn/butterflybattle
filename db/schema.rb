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

ActiveRecord::Schema.define(version: 20141203023230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.string   "userID"
    t.string   "pName"
    t.integer  "pHealth"
    t.integer  "pDefense"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pColor"
    t.string   "pDefenseAbility"
    t.string   "pOffenseAbility"
    t.string   "pWildAbility"
    t.integer  "p_max_health"
    t.integer  "p_cur_health"
    t.integer  "npc_max_health"
    t.integer  "npc_cur_health"
    t.integer  "p_max_speed"
    t.integer  "p_cur_speed"
    t.integer  "p_max_armor"
    t.integer  "p_cur_armor"
    t.integer  "p_max_attack"
    t.integer  "p_cur_attack"
    t.string   "p_name"
    t.string   "p_stat_boost"
    t.string   "p_wild"
    t.string   "p_offense"
    t.string   "p_defense"
    t.string   "p_last_move"
    t.integer  "npc_max_speed"
    t.integer  "npc_cur_speed"
    t.integer  "npc_max_armor"
    t.integer  "npc_cur_armor"
    t.integer  "npc_max_attack"
    t.integer  "npc_cur_attack"
    t.string   "npc_name"
    t.string   "p_color"
    t.string   "npc_wild"
    t.string   "npc_offense"
    t.string   "npc_defense"
    t.string   "npc_last_move"
    t.integer  "level"
    t.string   "p_id"
    t.boolean  "p_win"
    t.boolean  "npc_win"
    t.integer  "p_loss_counter"
    t.string   "npc_file"
    t.boolean  "npc_first"
    t.boolean  "p_first"
    t.boolean  "over"
    t.integer  "p_score"
    t.boolean  "retry"
    t.boolean  "bleed"
  end

  create_table "highscores", force: true do |t|
    t.integer  "p_score"
    t.string   "p_name"
    t.integer  "level"
    t.string   "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "npcs", force: true do |t|
    t.integer  "level"
    t.integer  "npc_max_health"
    t.integer  "npc_cur_health"
    t.integer  "npc_max_speed"
    t.integer  "npc_cur_speed"
    t.integer  "npc_max_armor"
    t.integer  "npc_cur_armor"
    t.integer  "npc_max_attack"
    t.integer  "npc_cur_attack"
    t.string   "npc_file"
    t.string   "npc_name"
    t.string   "npc_wild"
    t.string   "npc_offense"
    t.string   "npc_defense"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
