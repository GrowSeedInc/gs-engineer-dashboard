FactoryBot.define do
  factory :working_hour do
    association :user
    year_month { Date.new(2025, 4, 1) }
    record_type { "actual" }
    business_days { 21 }
    working_days { 20 }
    paid_leave_days { 1 }
    flex_days { 0 }
    special_leave_days { 0 }
    working_hours { 160.0 }
  end
end
