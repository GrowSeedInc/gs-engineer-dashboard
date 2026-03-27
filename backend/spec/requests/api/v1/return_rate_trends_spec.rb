require 'rails_helper'

RSpec.describe "Api::V1::ReturnRateTrends", type: :request do
  describe "GET /api/v1/return_rate_trends" do
    let!(:user) { create(:user) }
    let!(:trend_apr) { create(:return_rate_trend, user: user, year_month: Date.new(2025, 4, 1), return_rate: 70.00) }
    let!(:trend_may) { create(:return_rate_trend, user: user, year_month: Date.new(2025, 5, 1), return_rate: 68.50) }
    let!(:trend_jun) { create(:return_rate_trend, user: user, year_month: Date.new(2025, 6, 1), return_rate: 72.00) }

    context "認証済みの場合" do
      let(:headers) { auth_headers(sign_in_as(user)) }

      it "200を返すこと" do
        get "/api/v1/return_rate_trends", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "全ての還元率推移を年月順に返すこと" do
        get "/api/v1/return_rate_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(3)
        expect(body["trends"][0]["month"]).to eq("2025-04")
        expect(body["trends"][0]["return_rate"]).to eq(70.0)
      end

      it "ユーザー情報を含むこと" do
        get "/api/v1/return_rate_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["user"]["id"]).to eq(user.id)
      end

      it "fromパラメータで絞り込めること" do
        get "/api/v1/return_rate_trends", params: { from: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(2)
        expect(body["trends"][0]["month"]).to eq("2025-05")
      end

      it "toパラメータで絞り込めること" do
        get "/api/v1/return_rate_trends", params: { to: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(2)
        expect(body["trends"].last["month"]).to eq("2025-05")
      end

      it "fromとtoパラメータで絞り込めること" do
        get "/api/v1/return_rate_trends", params: { from: "2025-05", to: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(1)
        expect(body["trends"][0]["month"]).to eq("2025-05")
      end

      it "不正な日付フォーマットの場合は400を返すこと" do
        get "/api/v1/return_rate_trends", params: { from: "invalid" }, headers: headers
        expect(response).to have_http_status(:bad_request)
      end

      it "他のユーザーの還元率推移を返さないこと" do
        other_user = create(:user)
        create(:return_rate_trend, user: other_user, year_month: Date.new(2025, 7, 1))
        get "/api/v1/return_rate_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(3)
      end
    end

    context "未認証の場合" do
      it "401を返すこと" do
        get "/api/v1/return_rate_trends"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
