class Contract < ApplicationRecord
  belongs_to :user
  has_many :contract_month_statuses, dependent: :destroy

  validates :name, :unit_price, :period_start, :period_end, presence: true
end
