require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    let!(:user) { create(:user) }

    context "有効な認証情報の場合" do
      it "200とトークン・ユーザー情報を返すこと" do
        post "/api/v1/auth/sign_in",
          params: { user: { email: user.email, password: "password" } },
          as: :json

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["token"]).to be_present
        expect(body["user"]["email"]).to eq(user.email)
        expect(body["user"]["monthly_salary"]).to eq(700_000)
      end
    end

    context "パスワードが誤っている場合" do
      it "401を返すこと" do
        post "/api/v1/auth/sign_in",
          params: { user: { email: user.email, password: "wrong" } },
          as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "存在しないメールアドレスの場合" do
      it "401を返すこと" do
        post "/api/v1/auth/sign_in",
          params: { user: { email: "nobody@example.com", password: "password" } },
          as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    let!(:user) { create(:user) }

    it "ログイン済みの場合に204を返すこと" do
      token = sign_in_as(user)
      delete "/api/v1/auth/sign_out", headers: auth_headers(token)
      expect(response).to have_http_status(:no_content)
    end
  end
end
