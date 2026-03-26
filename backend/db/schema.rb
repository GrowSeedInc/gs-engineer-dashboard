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

ActiveRecord::Schema[7.2].define(version: 2025_09_01_000007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_month_statuses", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.date "year_month", null: false, comment: "対象年月（月初日）"
    t.boolean "is_ordered", default: false, null: false, comment: "受注済みかどうか"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id", "year_month"], name: "index_contract_month_statuses_on_contract_id_and_year_month", unique: true
    t.index ["contract_id"], name: "index_contract_month_statuses_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false, comment: "プロジェクト名"
    t.integer "unit_price", null: false, comment: "月額単価（円）"
    t.date "period_start", null: false, comment: "契約開始月（月初日）"
    t.date "period_end", null: false, comment: "契約終了月（月初日）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti", unique: true
  end

  create_table "return_rate_trends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "year_month", null: false, comment: "対象年月（月初日）"
    t.decimal "return_rate", precision: 5, scale: 2, comment: "還元率（%）。月額給与 ÷ 月額単価 × 100"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "year_month"], name: "index_return_rate_trends_on_user_id_and_year_month", unique: true
    t.index ["user_id"], name: "index_return_rate_trends_on_user_id"
  end

  create_table "sales_trends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "year_month", null: false, comment: "対象年月（月初日）"
    t.integer "actual_amount", comment: "実績金額（円）。未確定の場合はnull"
    t.integer "forecast_amount", comment: "予測金額（円）。実績確定済みの場合はnull"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "year_month"], name: "index_sales_trends_on_user_id_and_year_month", unique: true
    t.index ["user_id"], name: "index_sales_trends_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "monthly_salary", default: 0, null: false, comment: "月額給与（円）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_hours", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "year_month", null: false, comment: "対象年月（月初日）"
    t.string "record_type", null: false, comment: "実績: actual / 見込: forecast"
    t.integer "business_days", null: false, comment: "営業日数"
    t.integer "working_days", null: false, comment: "稼働日数"
    t.integer "paid_leave_days", default: 0, null: false, comment: "有給取得日数"
    t.integer "flex_days", default: 0, null: false, comment: "カット（フレックス）日数"
    t.integer "special_leave_days", default: 0, null: false, comment: "特別休暇日数"
    t.decimal "working_hours", precision: 6, scale: 2, null: false, comment: "稼働時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "year_month"], name: "index_working_hours_on_user_id_and_year_month", unique: true
    t.index ["user_id"], name: "index_working_hours_on_user_id"
  end

  add_foreign_key "contract_month_statuses", "contracts"
  add_foreign_key "contracts", "users"
  add_foreign_key "return_rate_trends", "users"
  add_foreign_key "sales_trends", "users"
  add_foreign_key "working_hours", "users"
end
