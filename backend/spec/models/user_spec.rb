require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効な属性であれば有効であること" do
      expect(build(:user)).to be_valid
    end

    it "名前がなければ無効であること" do
      expect(build(:user, name: "")).to be_invalid
    end

    it "メールアドレスがなければ無効であること" do
      expect(build(:user, email: "")).to be_invalid
    end

    it "重複したメールアドレスは無効であること" do
      create(:user, email: "dup@example.com")
      expect(build(:user, email: "dup@example.com")).to be_invalid
    end
  end

  describe "アソシエーション" do
    it "複数の売上推移を持つこと" do
      user = create(:user)
      create_list(:sales_trend, 2, user: user)
      expect(user.sales_trends.count).to eq(2)
    end

    it "複数の契約を持つこと" do
      user = create(:user)
      create_list(:contract, 2, user: user)
      expect(user.contracts.count).to eq(2)
    end

    it "ユーザー削除時に関連する売上推移も削除されること" do
      user = create(:user)
      create(:sales_trend, user: user)
      expect { user.destroy }.to change { SalesTrend.count }.by(-1)
    end
  end

  describe "#active_contract_at" do
    let(:user) { create(:user) }
    let(:date) { Date.new(2025, 6, 1) }

    it "指定日に有効な契約を返すこと" do
      contract = create(:contract, user: user, period_start: Date.new(2025, 4, 1), period_end: Date.new(2025, 9, 1))
      expect(user.active_contract_at(date)).to eq(contract)
    end

    it "有効な契約がない場合はnilを返すこと" do
      create(:contract, user: user, period_start: Date.new(2025, 7, 1), period_end: Date.new(2025, 12, 1))
      expect(user.active_contract_at(date)).to be_nil
    end

    it "複数の契約が合致する場合は最も直近に開始した契約を返すこと" do
      create(:contract, user: user, period_start: Date.new(2025, 4, 1), period_end: Date.new(2025, 9, 1))
      newer = create(:contract, user: user, name: "Newer", period_start: Date.new(2025, 5, 1), period_end: Date.new(2025, 9, 1))
      expect(user.active_contract_at(date)).to eq(newer)
    end
  end

  describe "#return_rate_at" do
    let(:user) { create(:user, monthly_salary: 700_000) }
    let(:date) { Date.new(2025, 6, 1) }

    it "正しい還元率を返すこと" do
      create(:contract, user: user, unit_price: 1_000_000,
        period_start: Date.new(2025, 4, 1), period_end: Date.new(2025, 9, 1))
      expect(user.return_rate_at(date)).to eq(70.0)
    end

    it "有効な契約がない場合は0.0を返すこと" do
      expect(user.return_rate_at(date)).to eq(0.0)
    end
  end
end
