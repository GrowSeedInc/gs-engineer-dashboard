class ContractMonthStatus < ApplicationRecord
  belongs_to :contract

  validates :year_month, presence: true, uniqueness: { scope: :contract_id }
end
