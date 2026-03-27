require 'rails_helper'

RSpec.describe "Api::V1::Contracts", type: :request do
  describe "GET /api/v1/contracts" do
    let!(:user) { create(:user) }
    let!(:contract) do
      create(:contract, user: user, name: "Project Alpha",
        unit_price: 1_000_000,
        period_start: Date.new(2025, 4, 1),
        period_end: Date.new(2026, 3, 1))
    end

    context "認証済みの場合" do
      let(:headers) { auth_headers(sign_in_as(user)) }

      it "200を返すこと" do
        get "/api/v1/contracts", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "表示月と契約一覧を返すこと" do
        get "/api/v1/contracts", params: { from: "2025-04", to: "2025-06" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["display_months"]).to eq(["2025-04", "2025-05", "2025-06"])
        expect(body["contracts"].length).to eq(1)
        expect(body["contracts"][0]["name"]).to eq("Project Alpha")
      end

      it "契約のフィールドを正しく返すこと" do
        get "/api/v1/contracts", params: { from: "2025-04", to: "2025-04" }, headers: headers
        body = JSON.parse(response.body)
        contract_json = body["contracts"][0]
        expect(contract_json["unit_price"]).to eq(1_000_000)
        expect(contract_json["period_start"]).to eq("2025-04")
        expect(contract_json["period_end"]).to eq("2026-03")
      end

      it "指定期間の月次ステータスを含むこと" do
        create(:contract_month_status, contract: contract, year_month: Date.new(2025, 4, 1), is_ordered: true)
        get "/api/v1/contracts", params: { from: "2025-04", to: "2025-04" }, headers: headers
        body = JSON.parse(response.body)
        statuses = body["contracts"][0]["monthly_statuses"]
        expect(statuses[0]["month"]).to eq("2025-04")
        expect(statuses[0]["is_ordered"]).to eq(true)
      end

      it "指定期間外の契約を除外すること" do
        create(:contract, user: user, name: "Old Project",
          period_start: Date.new(2024, 1, 1), period_end: Date.new(2024, 12, 1))
        get "/api/v1/contracts", params: { from: "2025-04", to: "2025-06" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["contracts"].map { |c| c["name"] }).not_to include("Old Project")
      end

      it "他のユーザーの契約を返さないこと" do
        other_user = create(:user)
        create(:contract, user: other_user, name: "Other Contract")
        get "/api/v1/contracts", params: { from: "2025-04", to: "2026-03" }, headers: headers
        body = JSON.parse(response.body)
        expect(body["contracts"].map { |c| c["name"] }).not_to include("Other Contract")
      end
    end

    context "未認証の場合" do
      it "401を返すこと" do
        get "/api/v1/contracts"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
