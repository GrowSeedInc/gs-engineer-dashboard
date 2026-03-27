FactoryBot.define do
  factory :return_rate_trend do
    association :user
    year_month { Date.new(2025, 4, 1) }
    return_rate { 70.00 }
  end
end
