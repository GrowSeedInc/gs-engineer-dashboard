FactoryBot.define do
  factory :contract do
    association :user
    name { Faker::Company.name }
    unit_price { 1_000_000 }
    period_start { Date.new(2025, 4, 1) }
    period_end { Date.new(2026, 3, 1) }
  end
end
