module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.order(:id).select(:id, :name, :email)
        render json: users.map { |u| { id: u.id, name: u.name, email: u.email } }
      end
    end
  end
end
