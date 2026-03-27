# frozen_string_literal: true

class CreateContractMonthStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :contract_month_statuses do |t|
      t.references :contract, null: false, foreign_key: true
      t.date    :year_month, null: false,         comment: "対象年月（月初日）"
      t.boolean :is_ordered, null: false, default: false, comment: "受注済みかどうか"

      t.timestamps
    end

    add_index :contract_month_statuses, [ :contract_id, :year_month ], unique: true
  end
end
