class SalesTrend < ApplicationRecord
  belongs_to :user

  validates :year_month, presence: true, uniqueness: { scope: :user_id }
end
