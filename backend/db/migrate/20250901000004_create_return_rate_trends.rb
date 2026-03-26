# frozen_string_literal: true

class CreateReturnRateTrends < ActiveRecord::Migration[7.2]
  def change
    create_table :return_rate_trends do |t|
      t.references :user, null: false, foreign_key: true
      t.date    :year_month,  null: false,  comment: "対象年月（月初日）"
      t.decimal :return_rate, precision: 5, scale: 2, comment: "還元率（%）。月額給与 ÷ 月額単価 × 100"

      t.timestamps
    end

    add_index :return_rate_trends, [ :user_id, :year_month ], unique: true
  end
end
