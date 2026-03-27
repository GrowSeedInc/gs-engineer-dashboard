require 'rails_helper'

RSpec.describe WorkingHour, type: :model do
  describe "バリデーション" do
    it "有効な属性であれば有効であること" do
      expect(build(:working_hour)).to be_valid
    end

    it "対象年月がなければ無効であること" do
      expect(build(:working_hour, year_month: nil)).to be_invalid
    end

    it "実績区分がなければ無効であること" do
      expect(build(:working_hour, record_type: nil)).to be_invalid
    end

    it "営業日数がなければ無効であること" do
      expect(build(:working_hour, business_days: nil)).to be_invalid
    end

    it "稼働日数がなければ無効であること" do
      expect(build(:working_hour, working_days: nil)).to be_invalid
    end

    it "稼働時間がなければ無効であること" do
      expect(build(:working_hour, working_hours: nil)).to be_invalid
    end

    it "同じユーザーで対象年月が重複する場合は無効であること" do
      user = create(:user)
      create(:working_hour, user: user, year_month: Date.new(2025, 4, 1))
      expect(build(:working_hour, user: user, year_month: Date.new(2025, 4, 1))).to be_invalid
    end
  end

  describe "enum record_type" do
    it "actualを受け付けること" do
      expect(build(:working_hour, record_type: "actual")).to be_valid
    end

    it "forecastを受け付けること" do
      expect(build(:working_hour, record_type: "forecast")).to be_valid
    end

    it "不正な値はArgumentErrorを発生させること" do
      expect { build(:working_hour, record_type: "unknown") }.to raise_error(ArgumentError)
    end
  end

  describe ".summary" do
    it "指定されたエントリの合計値を返すこと" do
      user = create(:user)
      entries = [
        create(:working_hour, user: user, year_month: Date.new(2025, 4, 1),
          business_days: 21, working_days: 20, paid_leave_days: 1,
          flex_days: 0, special_leave_days: 0, working_hours: 160.0),
        create(:working_hour, user: user, year_month: Date.new(2025, 5, 1),
          business_days: 20, working_days: 18, paid_leave_days: 2,
          flex_days: 0, special_leave_days: 0, working_hours: 144.0)
      ]

      summary = WorkingHour.summary(entries)

      expect(summary[:business_days]).to eq(41)
      expect(summary[:working_days]).to eq(38)
      expect(summary[:paid_leave_days]).to eq(3)
      expect(summary[:flex_days]).to eq(0)
      expect(summary[:special_leave_days]).to eq(0)
      expect(summary[:working_hours]).to eq(304.0)
    end

    it "エントリが空の場合はすべて0を返すこと" do
      summary = WorkingHour.summary([])
      expect(summary[:business_days]).to eq(0)
      expect(summary[:working_hours]).to eq(0)
    end
  end
end
