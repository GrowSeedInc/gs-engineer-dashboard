class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::BadRequest, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def user_json(user)
    { id: user.id, name: user.name, email: user.email }
  end

  def parse_year_month(str)
    Date.strptime(str, "%Y-%m").beginning_of_month
  rescue ArgumentError
    raise ActionController::BadRequest, "Invalid date format: '#{str}'. Expected YYYY-MM."
  end

  def not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def bad_request(e)
    render json: { error: e.message }, status: :bad_request
  end
end
