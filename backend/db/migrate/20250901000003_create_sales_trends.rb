# frozen_string_literal: true

class CreateSalesTrends < ActiveRecord::Migration[7.2]
  def change
    create_table :sales_trends do |t|
      t.references :user, null: false, foreign_key: true
      t.date    :year_month,       null: false,  comment: "対象年月（月初日）"
      t.integer :actual_amount,                  comment: "実績金額（円）。未確定の場合はnull"
      t.integer :forecast_amount,                comment: "予測金額（円）。実績確定済みの場合はnull"

      t.timestamps
    end

    add_index :sales_trends, [ :user_id, :year_month ], unique: true
  end
end
