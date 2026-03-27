module Api
  module V1
    class DashboardController < ApplicationController
      def show
        current_month = Date.current.beginning_of_month

        active_contract = current_user.contracts
          .where("period_start <= ? AND period_end >= ?", current_month, current_month)
          .order(period_start: :desc)
          .first

        monthly_unit_price = active_contract&.unit_price || 0
        monthly_salary = current_user.monthly_salary

        return_rate = if monthly_unit_price > 0
          (monthly_salary.to_f / monthly_unit_price * 100).round(2)
        else
          0.0
        end

        render json: {
          monthly_salary: monthly_salary,
          monthly_unit_price: monthly_unit_price,
          return_rate: return_rate
        }
      end
    end
  end
end
