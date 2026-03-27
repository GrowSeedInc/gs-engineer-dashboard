require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe "バリデーション" do
    it "有効な属性であれば有効であること" do
      expect(build(:contract)).to be_valid
    end

    it "プロジェクト名がなければ無効であること" do
      expect(build(:contract, name: "")).to be_invalid
    end

    it "月額単価がなければ無効であること" do
      expect(build(:contract, unit_price: nil)).to be_invalid
    end

    it "契約開始月がなければ無効であること" do
      expect(build(:contract, period_start: nil)).to be_invalid
    end

    it "契約終了月がなければ無効であること" do
      expect(build(:contract, period_end: nil)).to be_invalid
    end
  end

  describe "#monthly_statuses_for" do
    let(:contract) do
      create(:contract,
        period_start: Date.new(2025, 4, 1),
        period_end: Date.new(2025, 6, 1))
    end

    it "指定期間の各月のステータスを返すこと" do
      create(:contract_month_status, contract: contract, year_month: Date.new(2025, 4, 1), is_ordered: true)
      create(:contract_month_status, contract: contract, year_month: Date.new(2025, 5, 1), is_ordered: false)

      result = contract.monthly_statuses_for(Date.new(2025, 4, 1), Date.new(2025, 5, 1))

      expect(result.length).to eq(2)
      expect(result[0]).to eq({ month: "2025-04", is_ordered: true })
      expect(result[1]).to eq({ month: "2025-05", is_ordered: false })
    end

    it "ステータスレコードがない月はis_ordered: falseを返すこと" do
      result = contract.monthly_statuses_for(Date.new(2025, 4, 1), Date.new(2025, 4, 1))
      expect(result[0]).to eq({ month: "2025-04", is_ordered: false })
    end

    it "from_dateからto_dateまでの全ての月を返すこと" do
      result = contract.monthly_statuses_for(Date.new(2025, 4, 1), Date.new(2025, 6, 1))
      expect(result.map { |r| r[:month] }).to eq([ "2025-04", "2025-05", "2025-06" ])
    end
  end
end
