module Api
  module V1
    module Auth
      class SwitchController < ApplicationController
        def create
          target_user = User.find(params[:user_id])
          token, _payload = Warden::JWTAuth::UserEncoder.new.call(target_user, :user, nil)
          render json: {
            token: token,
            user: {
              id: target_user.id,
              name: target_user.name,
              email: target_user.email
            }
          }, status: :ok
        end
      end
    end
  end
end
