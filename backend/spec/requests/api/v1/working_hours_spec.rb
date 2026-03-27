require 'rails_helper'

RSpec.describe "Api::V1::WorkingHours", type: :request do
  describe "GET /api/v1/working_hours" do
    let!(:user) { create(:user) }

    context "認証済みの場合" do
      let(:headers) { auth_headers(sign_in_as(user)) }

      it "200を返すこと" do
        get "/api/v1/working_hours", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "actualとforecastのセクションにentriesとsummaryを含むこと" do
        get "/api/v1/working_hours", headers: headers
        body = JSON.parse(response.body)
        expect(body).to have_key("actual")
        expect(body).to have_key("forecast")
        expect(body["actual"]).to have_key("entries")
        expect(body["actual"]).to have_key("summary")
        expect(body["forecast"]).to have_key("entries")
        expect(body["forecast"]).to have_key("summary")
      end

      it "直近6ヶ月の実績エントリを返すこと" do
        travel_to Date.new(2026, 3, 1) do
          create(:working_hour, user: user, record_type: "actual",
            year_month: Date.new(2025, 10, 1), business_days: 23, working_days: 23,
            paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 184.0)
          create(:working_hour, user: user, record_type: "actual",
            year_month: Date.new(2025, 9, 1), business_days: 22, working_days: 22,
            paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0)

          get "/api/v1/working_hours", headers: auth_headers(sign_in_as(user))
          body = JSON.parse(response.body)
          months = body["actual"]["entries"].map { |e| e["month"] }
          expect(months).to include("2025-10")
          expect(months).not_to include("2025-09")
        end
      end

      it "翌月から6ヶ月分の見込エントリを返すこと" do
        travel_to Date.new(2026, 3, 1) do
          create(:working_hour, user: user, record_type: "forecast",
            year_month: Date.new(2026, 3, 1), business_days: 21, working_days: 21,
            paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0)
          create(:working_hour, user: user, record_type: "forecast",
            year_month: Date.new(2026, 9, 1), business_days: 22, working_days: 22,
            paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 176.0)

          get "/api/v1/working_hours", headers: auth_headers(sign_in_as(user))
          body = JSON.parse(response.body)
          months = body["forecast"]["entries"].map { |e| e["month"] }
          expect(months).to include("2026-03")
          expect(months).not_to include("2026-09")
        end
      end

      it "エントリのフィールドを正しく返すこと" do
        travel_to Date.new(2026, 3, 1) do
          create(:working_hour, user: user, record_type: "actual",
            year_month: Date.new(2026, 3, 1), business_days: 21, working_days: 20,
            paid_leave_days: 1, flex_days: 0, special_leave_days: 0, working_hours: 160.0)

          get "/api/v1/working_hours", headers: auth_headers(sign_in_as(user))
          body = JSON.parse(response.body)
          entry = body["actual"]["entries"].find { |e| e["month"] == "2026-03" }
          expect(entry["business_days"]).to eq(21)
          expect(entry["working_days"]).to eq(20)
          expect(entry["paid_leave_days"]).to eq(1)
          expect(entry["working_hours"]).to eq(160.0)
        end
      end

      it "他のユーザーの稼働時間を返さないこと" do
        travel_to Date.new(2026, 3, 1) do
          other_user = create(:user)
          create(:working_hour, user: other_user, record_type: "actual",
            year_month: Date.new(2026, 3, 1), business_days: 21, working_days: 21,
            paid_leave_days: 0, flex_days: 0, special_leave_days: 0, working_hours: 168.0)

          get "/api/v1/working_hours", headers: auth_headers(sign_in_as(user))
          body = JSON.parse(response.body)
          expect(body["actual"]["entries"]).to be_empty
        end
      end
    end

    context "未認証の場合" do
      it "401を返すこと" do
        get "/api/v1/working_hours"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
