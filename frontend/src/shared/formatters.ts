export const formatYearMonth = (yyyyMM: string): string => {
  const [year, month] = yyyyMM.split('-')
  return `${year}年${Number(month)}月`
}

export const formatCurrency = (value: number): string =>
  `¥${value.toLocaleString('ja-JP')}`

export const formatPercent = (value: number): string =>
  `${value.toFixed(1)}%`
