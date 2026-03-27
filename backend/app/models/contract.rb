class Contract < ApplicationRecord
  belongs_to :user
  has_many :contract_month_statuses, dependent: :destroy

  validates :name, :unit_price, :period_start, :period_end, presence: true

  def monthly_statuses_for(from_date, to_date)
    statuses_by_month = contract_month_statuses
      .select { |s| s.year_month >= from_date && s.year_month <= to_date }
      .index_by { |s| s.year_month.strftime("%Y-%m") }

    (from_date..to_date)
      .select { |d| d.day == 1 }
      .map { |d|
        month_str = d.strftime("%Y-%m")
        status = statuses_by_month[month_str]
        { month: month_str, is_ordered: status&.is_ordered || false }
      }
  end
end
