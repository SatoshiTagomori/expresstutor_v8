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

ActiveRecord::Schema.define(version: 2021_06_30_101306) do

  create_table "access_logs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "line_user_id", null: false
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_access_logs_on_line_user_id"
  end

  create_table "courses", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "price"
    t.integer "tickets"
    t.string "valid_date"
    t.boolean "status", default: true
    t.boolean "subscription", default: true
    t.string "comment"
    t.string "price_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_users", charset: "utf8mb4", force: :cascade do |t|
    t.string "line_id"
    t.string "display_name"
    t.string "picture"
    t.boolean "admin", default: false
    t.boolean "teacher", default: false
    t.string "customer"
    t.string "subscription"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_errors", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "line_user_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_payment_errors_on_line_user_id"
  end

  create_table "payment_logs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "line_user_id", null: false
    t.bigint "course_id", null: false
    t.string "subscription"
    t.string "payment_intent"
    t.text "log"
    t.boolean "refund", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_payment_logs_on_course_id"
    t.index ["line_user_id"], name: "index_payment_logs_on_line_user_id"
  end

  create_table "prefs", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profiles", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "line_user_id", null: false
    t.string "email"
    t.string "name"
    t.string "cname"
    t.bigint "pref_id", null: false
    t.string "tel"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_profiles_on_line_user_id"
    t.index ["pref_id"], name: "index_profiles_on_pref_id"
  end

  create_table "tickets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "line_user_id", null: false
    t.bigint "payment_log_id", null: false
    t.string "subscription"
    t.datetime "valid_date"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_tickets_on_line_user_id"
    t.index ["payment_log_id"], name: "index_tickets_on_payment_log_id"
  end

  add_foreign_key "access_logs", "line_users"
  add_foreign_key "payment_errors", "line_users"
  add_foreign_key "payment_logs", "courses"
  add_foreign_key "payment_logs", "line_users"
  add_foreign_key "profiles", "line_users"
  add_foreign_key "profiles", "prefs"
  add_foreign_key "tickets", "line_users"
  add_foreign_key "tickets", "payment_logs"
end
