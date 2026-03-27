module Api
  module V1
    class ReturnRateTrendsController < ApplicationController
      def index
        trends = current_user.return_rate_trends.order(:year_month)
        trends = trends.where("year_month >= ?", parse_year_month(params[:from])) if params[:from].present?
        trends = trends.where("year_month <= ?", parse_year_month(params[:to])) if params[:to].present?

        render json: {
          user: user_json(current_user),
          trends: trends.map { |t|
            {
              month: t.year_month.strftime("%Y-%m"),
              return_rate: t.return_rate&.to_f
            }
          }
        }
      end
    end
  end
end
