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
end
