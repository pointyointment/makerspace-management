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

ActiveRecord::Schema.define(version: 20190115153427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_reports", force: :cascade do |t|
    t.datetime "shift_start", null: false
    t.datetime "shift_end",   null: false
    t.text     "notes",       null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_daily_reports_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",             null: false
    t.string   "audience",         null: false
    t.string   "org_name",         null: false
    t.string   "org_contact_name", null: false
    t.text     "desc",             null: false
    t.datetime "event_start",      null: false
    t.datetime "event_end",        null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "punches", force: :cascade do |t|
    t.boolean  "in",         null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "reason"
    t.index ["user_id"], name: "index_punches_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key",           null: false
    t.text     "value"
    t.integer  "base_obj_id"
    t.string   "base_obj_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["base_obj_id"], name: "index_settings_on_base_obj_id", unique: true, using: :btree
    t.index ["base_obj_type"], name: "index_settings_on_base_obj_type", unique: true, using: :btree
    t.index ["key"], name: "index_settings_on_key", unique: true, using: :btree
  end

  create_table "signups", force: :cascade do |t|
    t.integer  "signup_day",   null: false
    t.time     "signup_start"
    t.integer  "signup_qty",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "trainings", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "training_type", null: false
    t.string   "icon"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "user_signups", id: false, force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "signup_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id", null: false
    t.index ["created_by_id"], name: "index_user_signups_on_created_by_id", using: :btree
    t.index ["signup_id"], name: "index_user_signups_on_signup_id", using: :btree
    t.index ["user_id", "signup_id"], name: "index_user_signups_on_user_id_and_signup_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_signups_on_user_id", using: :btree
  end

  create_table "user_trainings", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "training_id",   null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id", null: false
    t.index ["created_by_id"], name: "index_user_trainings_on_created_by_id", using: :btree
    t.index ["training_id"], name: "index_user_trainings_on_training_id", using: :btree
    t.index ["user_id", "training_id"], name: "index_user_trainings_on_user_id_and_training_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_trainings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.string   "github_username"
    t.string   "profile_image_url"
    t.string   "position_name"
    t.datetime "member_since",                        null: false
    t.text     "biography"
    t.string   "card_id"
    t.string   "user_type",                           null: false
    t.text     "specialties"
    t.text     "interests"
    t.string   "slack_user_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "user_signups", "users", column: "created_by_id"
  add_foreign_key "user_trainings", "users", column: "created_by_id"
end
