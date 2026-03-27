require 'rails_helper'

RSpec.describe SalesTrend, type: :model do
  describe "バリデーション" do
    it "有効な属性であれば有効であること" do
      expect(build(:sales_trend)).to be_valid
    end

    it "対象年月がなければ無効であること" do
      expect(build(:sales_trend, year_month: nil)).to be_invalid
    end

    it "同じユーザーで対象年月が重複する場合は無効であること" do
      user = create(:user)
      create(:sales_trend, user: user, year_month: Date.new(2025, 4, 1))
      expect(build(:sales_trend, user: user, year_month: Date.new(2025, 4, 1))).to be_invalid
    end

    it "異なるユーザーであれば同じ対象年月でも有効であること" do
      create(:sales_trend, year_month: Date.new(2025, 4, 1))
      other = build(:sales_trend, year_month: Date.new(2025, 4, 1))
      expect(other).to be_valid
    end
  end
end
