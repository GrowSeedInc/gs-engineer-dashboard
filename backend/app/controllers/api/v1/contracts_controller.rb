module Api
  module V1
    class ContractsController < ApplicationController
      def index
        from_date = params[:from].present? ? parse_year_month(params[:from]) : Date.current.beginning_of_month
        to_date   = params[:to].present?   ? parse_year_month(params[:to])   : from_date + 11.months

        display_months = (from_date..to_date).select { |d| d.day == 1 }.map { |d| d.strftime("%Y-%m") }

        contracts = current_user.contracts
          .where("period_start <= ? AND period_end >= ?", to_date, from_date)
          .includes(:contract_month_statuses)
          .order(:period_start)

        render json: {
          display_months: display_months,
          contracts: contracts.map { |c| contract_json(c, from_date, to_date) }
        }
      end

      private

      def parse_year_month(str)
        Date.strptime(str, "%Y-%m").beginning_of_month
      end

      def contract_json(contract, from_date, to_date)
        statuses_by_month = contract.contract_month_statuses
          .select { |s| s.year_month >= from_date && s.year_month <= to_date }
          .index_by { |s| s.year_month.strftime("%Y-%m") }

        monthly_statuses = (from_date..to_date)
          .select { |d| d.day == 1 }
          .map { |d|
            month_str = d.strftime("%Y-%m")
            status = statuses_by_month[month_str]
            { month: month_str, is_ordered: status&.is_ordered || false }
          }

        {
          id: contract.id,
          name: contract.name,
          unit_price: contract.unit_price,
          period_start: contract.period_start.strftime("%Y-%m"),
          period_end: contract.period_end.strftime("%Y-%m"),
          monthly_statuses: monthly_statuses
        }
      end
    end
  end
end
