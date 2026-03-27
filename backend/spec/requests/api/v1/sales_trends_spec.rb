require 'rails_helper'

RSpec.describe "Api::V1::SalesTrends", type: :request do
  describe "GET /api/v1/sales_trends" do
    let!(:user) { create(:user) }
    let!(:trend_apr) { create(:sales_trend, user: user, year_month: Date.new(2025, 4, 1), actual_amount: 1_000_000, forecast_amount: nil) }
    let!(:trend_may) { create(:sales_trend, user: user, year_month: Date.new(2025, 5, 1), actual_amount: 900_000, forecast_amount: nil) }
    let!(:trend_jun) { create(:sales_trend, user: user, year_month: Date.new(2025, 6, 1), actual_amount: nil, forecast_amount: 950_000) }

    context "認証済みの場合" do
      let(:headers) { auth_headers(sign_in_as(user)) }

      it "200を返すこと" do
        get "/api/v1/sales_trends", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "全ての売上推移を年月順に返すこと" do
        get "/api/v1/sales_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(3)
        expect(body["trends"][0]["month"]).to eq("2025-04")
        expect(body["trends"][0]["actual_amount"]).to eq(1_000_000)
      end

      it "ユーザー情報を含むこと" do
        get "/api/v1/sales_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["user"]["id"]).to eq(user.id)
      end

      it "fromパラメータで絞り込めること" do
        get "/api/v1/sales_trends", params: { from: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(2)
        expect(body["trends"][0]["month"]).to eq("2025-05")
      end

      it "toパラメータで絞り込めること" do
        get "/api/v1/sales_trends", params: { to: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(2)
        expect(body["trends"].last["month"]).to eq("2025-05")
      end

      it "fromとtoパラメータで絞り込めること" do
        get "/api/v1/sales_trends", params: { from: "2025-05", to: "2025-05" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(1)
        expect(body["trends"][0]["month"]).to eq("2025-05")
      end

      it "不正な日付フォーマットの場合は400を返すこと" do
        get "/api/v1/sales_trends", params: { from: "invalid" }, headers: headers
        expect(response).to have_http_status(:bad_request)
      end

      it "他のユーザーの売上推移を返さないこと" do
        other_user = create(:user)
        create(:sales_trend, user: other_user, year_month: Date.new(2025, 7, 1))
        get "/api/v1/sales_trends", headers: headers
        body = JSON.parse(response.body)
        expect(body["trends"].length).to eq(3)
      end
    end

    context "未認証の場合" do
      it "401を返すこと" do
        get "/api/v1/sales_trends"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
