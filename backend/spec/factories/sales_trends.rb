FactoryBot.define do
  factory :sales_trend do
    association :user
    sequence(:year_month) { |n| Date.new(2025, 1, 1) >> (n - 1) }
    actual_amount { 1_000_000 }
    forecast_amount { nil }
  end
end
