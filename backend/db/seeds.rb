# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 旧シードユーザーの削除
%w[test@example.com tanaka@example.com sato@example.com].each do |old_email|
  User.find_by(email: old_email)&.destroy
end

def seed_user(email:, name:, monthly_salary:, contracts_spec:, actual_working_hours:, forecast_working_hours:)
  user = User.find_or_create_by!(email: email) do |u|
    u.name = name
    u.password = "password"
    u.password_confirmation = "password"
    u.monthly_salary = monthly_salary
  end
  user.update!(monthly_salary: monthly_salary)

  # 既存データのクリア（再実行時にリセット）
  ContractMonthStatus.joins(:contract).where(contracts: { user_id: user.id }).delete_all
  Contract.where(user: user).delete_all
  SalesTrend.where(user: user).delete_all
  ReturnRateTrend.where(user: user).delete_all
  WorkingHour.where(user: user).delete_all

  today         = Date.current
  current_month = today.beginning_of_month
  past_6        = current_month << 6
  future_6      = current_month >> 6
  all_months    = (0..12).map { |i| past_6 >> i }

  contracts = contracts_spec.map do |spec|
    Contract.create!(
      user: user,
      name: spec[:name],
      unit_price: spec[:unit_price],
      period_start: spec[:period_start].call(current_month),
      period_end:   spec[:period_end].call(current_month)
    )
  end

  unit_price_for = lambda do |ym|
    total = contracts.sum do |c|
      (ym >= c.period_start && ym <= c.period_end) ? c.unit_price : 0
    end
    total.positive? ? total : nil
  end

  # contract_month_statuses
  all_months.each do |ym|
    contracts.each do |c|
      next unless ym >= c.period_start && ym <= c.period_end

      ContractMonthStatus.create!(
        contract: c,
        year_month: ym,
        is_ordered: ym <= current_month
      )
    end
  end

  # 売上データ
  all_months.each do |ym|
    amount = unit_price_for.call(ym)
    SalesTrend.create!(
      user: user,
      year_month: ym,
      actual_amount:   ym < current_month ? amount : nil,
      forecast_amount: ym >= current_month ? amount : nil
    )
  end

  # 還元率データ
  all_months.each do |ym|
    unit_price = unit_price_for.call(ym)
    ReturnRateTrend.create!(
      user: user,
      year_month: ym,
      return_rate: unit_price ? (user.monthly_salary.to_f / unit_price * 100).round(1) : nil
    )
  end

  # 稼働時間データ（実績: 5ヶ月前〜1ヶ月前）
  actual_months = (0..4).map { |i| (current_month << 5) >> i }
  actual_months.each_with_index do |ym, i|
    spec = actual_working_hours[i]
    WorkingHour.create!(
      user: user,
      year_month: ym,
      record_type: "actual",
      business_days:    spec[:business_days],
      working_days:     spec[:working_days],
      paid_leave_days:  spec[:paid_leave_days],
      flex_days:        spec[:flex_days],
      special_leave_days: spec[:special_leave_days],
      working_hours:    spec[:working_hours]
    )
  end

  # 稼働時間データ（見込: 当月〜5ヶ月後）
  forecast_months = (0..5).map { |i| current_month >> i }
  forecast_months.each_with_index do |ym, i|
    spec = forecast_working_hours[i]
    WorkingHour.create!(
      user: user,
      year_month: ym,
      record_type: "forecast",
      business_days:    spec[:business_days],
      working_days:     spec[:working_days],
      paid_leave_days:  spec[:paid_leave_days],
      flex_days:        spec[:flex_days],
      special_leave_days: spec[:special_leave_days],
      working_hours:    spec[:working_hours]
    )
  end

  user
end

# -------------------------------------------------------
# ユーザー 1: 山田 一郎（経験5年・中堅）
#   月額給与: 520,000円
#   案件①「ECサイト基盤刷新」     750,000円 (7ヶ月前〜2ヶ月前)
#   案件②「金融系API開発」        900,000円 (3ヶ月前〜5ヶ月後)
#   ※重複期間(3ヶ月前〜2ヶ月前)の単価合計: 1,650,000円
#   還元率: 単独期間 ~69%、重複期間 ~31%、金融系のみ ~58%
# -------------------------------------------------------
seed_user(
  email: "yamada@example.com",
  name: "山田 一郎",
  monthly_salary: 520_000,
  contracts_spec: [
    {
      name: "ECサイト基盤刷新",
      unit_price: 750_000,
      period_start: ->(cm) { cm << 7 },
      period_end:   ->(cm) { cm << 2 }
    },
    {
      name: "金融系API開発",
      unit_price: 900_000,
      period_start: ->(cm) { cm << 3 },
      period_end:   ->(cm) { cm >> 5 }
    }
  ],
  # 実績: 5ヶ月前〜1ヶ月前
  actual_working_hours: [
    { business_days: 21, working_days: 20, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 22, working_days: 22, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 20, working_days: 18, paid_leave_days: 2, flex_days: 0, special_leave_days: 0, working_hours: 144.0 },
    { business_days: 23, working_days: 22, paid_leave_days: 0, flex_days: 1, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 21, working_days: 21, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0 }
  ],
  # 見込: 当月〜5ヶ月後
  forecast_working_hours: [
    { business_days: 22, working_days: 21, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 20, working_days: 20, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 21, working_days: 20, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 23, working_days: 23, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 184.0 },
    { business_days: 20, working_days: 19, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 152.0 },
    { business_days: 22, working_days: 22, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0 }
  ]
)

# -------------------------------------------------------
# ユーザー 2: 鈴木 健太（経験10年・シニア）
#   月額給与: 720,000円
#   案件「製造業DXプラットフォーム」  1,150,000円 (6ヶ月前〜6ヶ月後)
#   還元率: ~62.6%
# -------------------------------------------------------
seed_user(
  email: "suzuki@example.com",
  name: "鈴木 健太",
  monthly_salary: 720_000,
  contracts_spec: [
    {
      name: "製造業DXプラットフォーム",
      unit_price: 1_150_000,
      period_start: ->(cm) { cm << 6 },
      period_end:   ->(cm) { cm >> 6 }
    }
  ],
  # 実績: 5ヶ月前〜1ヶ月前
  actual_working_hours: [
    { business_days: 21, working_days: 21, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 22, working_days: 20, paid_leave_days: 2, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 20, working_days: 20, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 23, working_days: 21, paid_leave_days: 1, flex_days: 1, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 21, working_days: 19, paid_leave_days: 2, flex_days: 0, special_leave_days: 0, working_hours: 152.0 }
  ],
  # 見込: 当月〜5ヶ月後
  forecast_working_hours: [
    { business_days: 22, working_days: 22, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 20, working_days: 18, paid_leave_days: 2, flex_days: 0, special_leave_days: 0, working_hours: 144.0 },
    { business_days: 21, working_days: 21, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 23, working_days: 22, paid_leave_days: 0, flex_days: 1, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 20, working_days: 20, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 22, working_days: 20, paid_leave_days: 1, flex_days: 1, special_leave_days: 0, working_hours: 160.0 }
  ]
)

# -------------------------------------------------------
# ユーザー 3: 高橋 美咲（経験3年・ジュニア〜中堅）
#   月額給与: 350,000円
#   案件①「物流管理システム改修」  550,000円 (4ヶ月前〜3ヶ月後)
#   案件②「社内業務ツール開発」    480,000円 (2ヶ月後〜6ヶ月後)
#   ※重複期間(2ヶ月後〜3ヶ月後)の単価合計: 1,030,000円
#   還元率: 物流のみ ~63.6%、重複期間 ~34.0%、業務ツールのみ ~72.9%
# -------------------------------------------------------
seed_user(
  email: "takahashi@example.com",
  name: "高橋 美咲",
  monthly_salary: 350_000,
  contracts_spec: [
    {
      name: "物流管理システム改修",
      unit_price: 550_000,
      period_start: ->(cm) { cm << 4 },
      period_end:   ->(cm) { cm >> 3 }
    },
    {
      name: "社内業務ツール開発",
      unit_price: 480_000,
      period_start: ->(cm) { cm >> 2 },
      period_end:   ->(cm) { cm >> 6 }
    }
  ],
  # 実績: 5ヶ月前〜1ヶ月前
  actual_working_hours: [
    { business_days: 21, working_days: 21, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 22, working_days: 21, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 20, working_days: 20, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 23, working_days: 22, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 21, working_days: 20, paid_leave_days: 0, flex_days: 1, special_leave_days: 0, working_hours: 160.0 }
  ],
  # 見込: 当月〜5ヶ月後
  forecast_working_hours: [
    { business_days: 22, working_days: 22, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0 },
    { business_days: 20, working_days: 19, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 152.0 },
    { business_days: 21, working_days: 21, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0 },
    { business_days: 23, working_days: 23, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 184.0 },
    { business_days: 20, working_days: 20, paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 160.0 },
    { business_days: 22, working_days: 21, paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 168.0 }
  ]
)

puts "Seed data created successfully!"
puts "  Users: #{User.count}"
puts "  Contracts: #{Contract.count}"
puts "  ContractMonthStatuses: #{ContractMonthStatus.count}"
puts "  SalesTrends: #{SalesTrend.count}"
puts "  ReturnRateTrends: #{ReturnRateTrend.count}"
puts "  WorkingHours: #{WorkingHour.count}"
