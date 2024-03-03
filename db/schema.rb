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

ActiveRecord::Schema[7.1].define(version: 2024_01_02_181122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fines", force: :cascade do |t|
    t.string "_id", null: false
    t.string "reason", null: false
    t.string "place", null: false
    t.datetime "issue_time", null: false
    t.float "amount", null: false
    t.boolean "payment_status", default: false
    t.float "penalty_amount", default: 0.0
    t.bigint "user_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "vehicle_plate_number"
    t.string "user_name"
    t.string "user_surname"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "subject", null: false
    t.string "body", null: false
    t.boolean "published", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: :cascade do |t|
    t.string "credit_card_number", null: false
    t.string "expiration_date", null: false
    t.string "card_verification_number", null: false
    t.float "amount", default: 0.0
    t.bigint "fine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fine_id"], name: "index_payments_on_fine_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.string "national_identification_number"
    t.date "date_of_birth"
    t.string "phone_number"
    t.string "role", default: "Individual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate_number", null: false
    t.string "vehicle_type"
    t.string "make"
    t.integer "production_year"
    t.bigint "user_id"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

end
