class WorkingHours < ApplicationRecord
  belongs_to :user

  enum :record_type, { actual: "actual", forecast: "forecast" }

  validates :year_month, presence: true, uniqueness: { scope: :user_id }
  validates :record_type, presence: true
  validates :business_days, :working_days, :working_hours, presence: true

  def self.summary(entries)
    {
      business_days: entries.sum(&:business_days),
      working_days: entries.sum(&:working_days),
      paid_leave_days: entries.sum(&:paid_leave_days),
      flex_days: entries.sum(&:flex_days),
      special_leave_days: entries.sum(&:special_leave_days),
      working_hours: entries.sum { |e| e.working_hours.to_f }
    }
  end
end
