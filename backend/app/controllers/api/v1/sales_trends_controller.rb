module Api
  module V1
    class SalesTrendsController < ApplicationController
      def index
        trends = current_user.sales_trends.order(:year_month)
        trends = trends.where("year_month >= ?", parse_year_month(params[:from])) if params[:from].present?
        trends = trends.where("year_month <= ?", parse_year_month(params[:to])) if params[:to].present?

        render json: {
          user: user_json(current_user),
          trends: trends.map { |t|
            {
              month: t.year_month.strftime("%Y-%m"),
              actual_amount: t.actual_amount,
              forecast_amount: t.forecast_amount
            }
          }
        }
      end

      private

      def parse_year_month(str)
        Date.strptime(str, "%Y-%m").beginning_of_month
      end
    end
  end
end
