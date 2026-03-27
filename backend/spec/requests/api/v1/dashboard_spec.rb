require 'rails_helper'

RSpec.describe "Api::V1::Dashboard", type: :request do
  describe "GET /api/v1/dashboard" do
    let!(:user) { create(:user, monthly_salary: 700_000) }

    context "認証済みの場合" do
      let(:headers) { auth_headers(sign_in_as(user)) }

      it "200を返すこと" do
        get "/api/v1/dashboard", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "月額給与を返すこと" do
        get "/api/v1/dashboard", headers: headers
        body = JSON.parse(response.body)
        expect(body["monthly_salary"]).to eq(700_000)
      end

      it "有効な契約の月額単価を返すこと" do
        travel_to Date.new(2026, 3, 1) do
          create(:contract, user: user, unit_price: 1_000_000,
            period_start: Date.new(2026, 1, 1), period_end: Date.new(2026, 6, 1))
          get "/api/v1/dashboard", headers: auth_headers(sign_in_as(user))
          body = JSON.parse(response.body)
          expect(body["monthly_unit_price"]).to eq(1_000_000)
        end
      end

      it "有効な契約がない場合は月額単価に0を返すこと" do
        get "/api/v1/dashboard", headers: headers
        body = JSON.parse(response.body)
        expect(body["monthly_unit_price"]).to eq(0)
      end

      it "還元率を返すこと" do
        get "/api/v1/dashboard", headers: headers
        body = JSON.parse(response.body)
        expect(body).to have_key("return_rate")
      end
    end

    context "未認証の場合" do
      it "401を返すこと" do
        get "/api/v1/dashboard"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
