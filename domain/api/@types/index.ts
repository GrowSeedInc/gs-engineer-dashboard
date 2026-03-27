/* eslint-disable */
export type User = {
  id: number;
  name: string;
  email: string;
}

export type DashboardSummary = {
  /** 月額給与（円） */
  monthly_salary: number;
  /** 月額単価・税抜（円） */
  monthly_unit_price: number;
  /** 還元率（%）。計算式：月額給与 ÷ 月額単価（税抜）× 100 */
  return_rate: number;
}

export type SalesTrend = {
  /** 対象年月（YYYY-MM形式） */
  month: string;
  /** 実績金額（円）。未確定の場合はnull */
  actual_amount?: number | null | undefined;
  /** 予測金額（円）。実績確定済みの場合はnull */
  forecast_amount?: number | null | undefined;
}

export type SalesTrendList = {
  user: User;
  trends: SalesTrend[];
}

export type ReturnRateTrend = {
  /** 対象年月（YYYY-MM形式） */
  month: string;
  /** 還元率（%）。計算式：月額給与 ÷ 月額単価（税抜）× 100 */
  return_rate?: number | null | undefined;
}

export type ReturnRateTrendList = {
  user: User;
  trends: ReturnRateTrend[];
}

export type Contract = {
  id: number;
  /** プロジェクト名 */
  name: string;
  /** 月額単価（円） */
  unit_price: number;
  /** 契約開始年月（YYYY-MM形式） */
  period_start: string;
  /** 契約終了年月（YYYY-MM形式） */
  period_end: string;
  /** 表示期間内の月別受注状況 */
  monthly_statuses: ContractMonthStatus[];
}

export type ContractList = {
  /** 表示対象の年月一覧（YYYY-MM形式） */
  display_months: string[];
  contracts: Contract[];
}

export type WorkingHoursDetail = {
  user: User;

  /** 過去6ヶ月（実績） */
  actual: {
    entries: WorkingHoursEntry[];
    summary: WorkingHoursSummary;
  };

  /** 将来6ヶ月（見込） */
  forecast: {
    entries: WorkingHoursEntry[];
    summary: WorkingHoursSummary;
  };
}

export type Error = {
  /** エラーコード */
  code: string;
  /** エラーメッセージ */
  message: string;
}

/** 契約の月別受注状況 */
export type ContractMonthStatus = {
  /** 対象年月（YYYY-MM形式） */
  month: string;
  /** 受注済みかどうか */
  is_ordered: boolean;
}

/** 月別稼働時間 */
export type WorkingHoursEntry = {
  /** 対象年月（YYYY-MM形式） */
  month: string;
  /** 営業日数 */
  business_days: number;
  /** 稼働日数 */
  working_days: number;
  /** 有給取得日数 */
  paid_leave_days: number;
  /** フレックス取得日数 */
  flex_days: number;
  /** 特別休暇日数 */
  special_leave_days: number;
  /** 稼働時間 */
  working_hours: number;
}

/** 合計行 */
export type WorkingHoursSummary = {
  business_days: number;
  working_days: number;
  paid_leave_days: number;
  flex_days: number;
  special_leave_days: number;
  working_hours: number;
}
