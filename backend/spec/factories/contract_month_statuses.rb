FactoryBot.define do
  factory :contract_month_status do
    association :contract
    year_month { Date.new(2025, 4, 1) }
    is_ordered { true }
  end
end
