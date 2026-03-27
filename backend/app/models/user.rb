class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :sales_trends, dependent: :destroy
  has_many :return_rate_trends, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :working_hours, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def active_contract_at(date)
    contracts
      .where("period_start <= ? AND period_end >= ?", date, date)
      .order(period_start: :desc)
      .first
  end

  def return_rate_at(date)
    contract = active_contract_at(date)
    unit_price = contract&.unit_price || 0
    return 0.0 if unit_price.zero?

    (monthly_salary.to_f / unit_price * 100).round(2)
  end
end
