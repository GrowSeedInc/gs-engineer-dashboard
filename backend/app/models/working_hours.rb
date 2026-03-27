class WorkingHours < ApplicationRecord
  belongs_to :user

  enum :record_type, { actual: "actual", forecast: "forecast" }

  validates :year_month, presence: true, uniqueness: { scope: :user_id }
  validates :record_type, presence: true
  validates :business_days, :working_days, :working_hours, presence: true
end
