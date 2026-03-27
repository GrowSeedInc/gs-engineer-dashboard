require 'rails_helper'

RSpec.describe ContractMonthStatus, type: :model do
  describe "バリデーション" do
    it "有効な属性であれば有効であること" do
      expect(build(:contract_month_status)).to be_valid
    end

    it "対象年月がなければ無効であること" do
      expect(build(:contract_month_status, year_month: nil)).to be_invalid
    end

    it "同じ契約内で対象年月が重複する場合は無効であること" do
      contract = create(:contract)
      create(:contract_month_status, contract: contract, year_month: Date.new(2025, 4, 1))
      expect(
        build(:contract_month_status, contract: contract, year_month: Date.new(2025, 4, 1))
      ).to be_invalid
    end

    it "異なる契約であれば同じ対象年月でも有効であること" do
      create(:contract_month_status, year_month: Date.new(2025, 4, 1))
      other = build(:contract_month_status, year_month: Date.new(2025, 4, 1))
      expect(other).to be_valid
    end
  end
end
