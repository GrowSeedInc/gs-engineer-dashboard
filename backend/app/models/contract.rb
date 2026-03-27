class Contract < ApplicationRecord
  belongs_to :user
  has_many :contract_month_statuses, dependent: :destroy

  validates :name, :unit_price, :period_start, :period_end, presence: true

  def monthly_statuses_for(from_date, to_date)
    statuses_by_month = contract_month_statuses
      .where(year_month: from_date..to_date)
      .index_by { |s| s.year_month.strftime("%Y-%m") }

    months_between(from_date, to_date).map { |month|
      month_str = month.strftime("%Y-%m")
      status = statuses_by_month[month_str]
      { month: month_str, is_ordered: status&.is_ordered || false }
    }
  end

  private

  def months_between(from_date, to_date)
    months = []
    month = from_date
    while month <= to_date
      months << month
      month = month >> 1
    end
    months
  end
end
