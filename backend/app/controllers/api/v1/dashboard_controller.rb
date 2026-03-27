module Api
  module V1
    class DashboardController < ApplicationController
      def show
        current_month = Date.current.beginning_of_month

        render json: {
          monthly_salary: current_user.monthly_salary,
          monthly_unit_price: current_user.active_contract_at(current_month)&.unit_price || 0,
          return_rate: current_user.return_rate_at(current_month)
        }
      end
    end
  end
end
