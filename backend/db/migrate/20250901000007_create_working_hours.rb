# frozen_string_literal: true

class CreateWorkingHours < ActiveRecord::Migration[7.2]
  def change
    create_table :working_hours do |t|
      t.references :user,   null: false, foreign_key: true
      t.date   :year_month,         null: false,               comment: "対象年月（月初日）"
      t.string :record_type,        null: false,               comment: "実績: actual / 見込: forecast"
      t.integer :business_days,     null: false,               comment: "営業日数"
      t.integer :working_days,      null: false,               comment: "稼働日数"
      t.integer :paid_leave_days,   null: false, default: 0,   comment: "有給取得日数"
      t.integer :flex_days,         null: false, default: 0,   comment: "カット（フレックス）日数"
      t.integer :special_leave_days, null: false, default: 0,  comment: "特別休暇日数"
      t.decimal :working_hours,     null: false, precision: 6, scale: 2, comment: "稼働時間"

      t.timestamps
    end

    add_index :working_hours, [ :user_id, :year_month ], unique: true
  end
end
