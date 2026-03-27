module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json
        wrap_parameters :user, include: [ :email, :password ]
        skip_before_action :verify_signed_out_user, only: :destroy

        def destroy
          sign_out(current_user)
          head :no_content
        end

        private

        def respond_with(resource, _opts = {})
          token = request.env["warden-jwt_auth.token"]
          render json: {
            token: token,
            user: {
              id: resource.id,
              name: resource.name,
              email: resource.email,
              monthly_salary: resource.monthly_salary
            }
          }, status: :ok
        end
      end
    end
  end
end
