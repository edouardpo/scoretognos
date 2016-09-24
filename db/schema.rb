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

ActiveRecord::Schema.define(version: 20160924133619) do

  create_table "bets", force: :cascade do |t|
    t.integer  "user_score_id"
    t.integer  "fixture_id"
    t.integer  "points_gap_id"
    t.integer  "points"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "result"
    t.string   "bonus_off"
    t.string   "bonus_def"
  end

  add_index "bets", ["fixture_id"], name: "index_bets_on_fixture_id"
  add_index "bets", ["points_gap_id"], name: "index_bets_on_points_gap_id"
  add_index "bets", ["user_score_id"], name: "index_bets_on_user_score_id"

  create_table "championships", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "days", force: :cascade do |t|
    t.integer  "championship_id"
    t.datetime "date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.string   "name"
  end

  add_index "days", ["championship_id"], name: "index_days_on_championship_id"

  create_table "fixtures", force: :cascade do |t|
    t.integer  "day_id"
    t.integer  "team_a_id"
    t.integer  "team_b_id"
    t.integer  "score_a"
    t.integer  "score_b"
    t.string   "bonus_off"
    t.string   "bonus_def"
    t.datetime "starts_at"
    t.datetime "bets_start_at"
    t.datetime "bets_end_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "fixtures", ["day_id"], name: "index_fixtures_on_day_id"
  add_index "fixtures", ["team_a_id"], name: "index_fixtures_on_team_a_id"
  add_index "fixtures", ["team_b_id"], name: "index_fixtures_on_team_b_id"

  create_table "points_gaps", force: :cascade do |t|
    t.integer  "bottom"
    t.integer  "top"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "championship_id"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "teams", ["championship_id"], name: "index_teams_on_championship_id"

  create_table "user_scores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "championship_id"
    t.integer  "value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_scores", ["championship_id"], name: "index_user_scores_on_championship_id"
  add_index "user_scores", ["user_id"], name: "index_user_scores_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
