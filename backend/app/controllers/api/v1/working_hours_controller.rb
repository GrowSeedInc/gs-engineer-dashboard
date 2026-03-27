module Api
  module V1
    class WorkingHoursController < ApplicationController
      def index
        current_month = Date.current.beginning_of_month
        actual_from   = current_month - 5.months
        forecast_to   = current_month + 6.months - 1.month

        actual_entries   = current_user.working_hours.actual
          .where(year_month: actual_from..current_month)
          .order(:year_month)

        forecast_entries = current_user.working_hours.forecast
          .where(year_month: current_month..forecast_to)
          .order(:year_month)

        render json: {
          user: user_json(current_user),
          actual: {
            entries: actual_entries.map { |e| entry_json(e) },
            summary: WorkingHours.summary(actual_entries)
          },
          forecast: {
            entries: forecast_entries.map { |e| entry_json(e) },
            summary: WorkingHours.summary(forecast_entries)
          }
        }
      end

      private

      def entry_json(entry)
        {
          month: entry.year_month.strftime("%Y-%m"),
          business_days: entry.business_days,
          working_days: entry.working_days,
          paid_leave_days: entry.paid_leave_days,
          flex_days: entry.flex_days,
          special_leave_days: entry.special_leave_days,
          working_hours: entry.working_hours.to_f
        }
      end
    end
  end
end
