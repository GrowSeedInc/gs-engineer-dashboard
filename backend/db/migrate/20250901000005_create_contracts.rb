# frozen_string_literal: true

class CreateContracts < ActiveRecord::Migration[7.2]
  def change
    create_table :contracts do |t|
      t.references :user,  null: false, foreign_key: true
      t.string  :name,         null: false, comment: "プロジェクト名"
      t.integer :unit_price,   null: false, comment: "月額単価（円）"
      t.date    :period_start, null: false, comment: "契約開始月（月初日）"
      t.date    :period_end,   null: false, comment: "契約終了月（月初日）"

      t.timestamps
    end
  end
end
