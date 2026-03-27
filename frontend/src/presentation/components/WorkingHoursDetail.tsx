import { Box, Paper, Typography, Skeleton, Alert } from '@mui/material'
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth'
import type { WorkingHoursEntry, WorkingHoursSummary } from '@domain/api/@types'
import { useWorkingHours } from '@/application/hooks/useWorkingHours'
import { useAuthStore } from '@/stores/authStore'

const formatMonthLabel = (yyyyMM: string): string => {
  const [year, month] = yyyyMM.split('-')
  return `${year}/${Number(month)}`
}

const formatHours = (hours: number): string => `${hours.toFixed(2)}時間`

// 個別行: 2桁ゼロ埋め
const padDays = (n: number): string => String(n).padStart(2, '0')

type RowData = {
  label: string
  businessDays: string
  workingDays: string
  paidLeaveDays: string
  flexDays: string
  specialLeaveDays: string
  workingHours: string
}

const entryToRowData = (entry: WorkingHoursEntry): RowData => ({
  label: formatMonthLabel(entry.month),
  businessDays: `${padDays(entry.business_days)}営`,
  workingDays: `${padDays(entry.working_days)}稼`,
  paidLeaveDays: `${padDays(entry.paid_leave_days)}有`,
  flexDays: `${padDays(entry.flex_days)}Ｆ`,
  specialLeaveDays: `${padDays(entry.special_leave_days)}特`,
  workingHours: formatHours(entry.working_hours),
})

const summaryToRowData = (summary: WorkingHoursSummary): RowData => ({
  label: '合計',
  businessDays: `${summary.business_days}営`,
  workingDays: `${summary.working_days}稼`,
  paidLeaveDays: `${summary.paid_leave_days}有`,
  flexDays: `${summary.flex_days}Ｆ`,
  specialLeaveDays: `${summary.special_leave_days}特`,
  workingHours: formatHours(summary.working_hours),
})

const HEADER_LABELS = ['月', '営業日', '稼働日', '有給', 'フレックス', '特別', '稼働時間']
const GRID_COLS = 'repeat(7, 1fr)'

type WorkingHoursPanelProps = {
  title: string
  entries: WorkingHoursEntry[]
  summary: WorkingHoursSummary
  variant: 'actual' | 'forecast'
}

const WorkingHoursPanel = ({ title, entries, summary, variant }: WorkingHoursPanelProps) => {
  const isActual = variant === 'actual'
  const borderColor = isActual ? '#1976d2' : '#9e9e9e'
  const headerBg = isActual ? 'rgba(25,118,210,0.12)' : '#e0e0e0'
  const totalBg = isActual ? 'rgba(25,118,210,0.12)' : '#e0e0e0'
  const totalBorderColor = isActual ? '#1565c0' : '#bdbdbd'
  const iconColor = isActual ? 'primary' : 'disabled'

  const rows = entries.map(entryToRowData)
  const totalRow = summaryToRowData(summary)

  const DataCell = ({ value, align = 'center', color = 'text.primary' }: {
    value: string
    align?: 'left' | 'center' | 'right'
    color?: string
  }) => (
    <Typography
      variant="body2"
      sx={{ textAlign: align, color, whiteSpace: 'nowrap' }}
    >
      {value}
    </Typography>
  )

  return (
    <Box>
      {/* パネルタイトル */}
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          gap: 1,
          pb: 0.5,
          mb: 1,
          borderBottom: '2px solid',
          borderColor,
        }}
      >
        <CalendarMonthIcon color={iconColor} sx={{ fontSize: 20 }} />
        <Typography variant="h6" fontWeight="medium">
          {title}
        </Typography>
      </Box>

      {/* ヘッダー行 */}
      <Box
        sx={{
          display: 'grid',
          gridTemplateColumns: GRID_COLS,
          gap: 1,
          bgcolor: headerBg,
          px: 1.5,
          py: 1,
          borderRadius: 0.5,
          mb: 0,
        }}
      >
        {HEADER_LABELS.map((label, i) => (
          <Typography
            key={label}
            variant="caption"
            sx={{
              textAlign: i === 0 ? 'left' : i === 6 ? 'right' : 'center',
              fontWeight: 'medium',
            }}
          >
            {label}
          </Typography>
        ))}
      </Box>

      {/* データ行 */}
      <Box>
        {rows.map((row, idx) => (
          <Box
            key={row.label}
            sx={{
              display: 'grid',
              gridTemplateColumns: GRID_COLS,
              gap: 1,
              px: 1.5,
              py: 1,
              borderBottom: idx < rows.length - 1 ? '1px solid' : 'none',
              borderColor: '#f5f5f5',
            }}
          >
            <DataCell value={row.label} align="left" />
            <DataCell value={row.businessDays} color="#757575" />
            <DataCell value={row.workingDays} color="#1976d2" />
            <DataCell value={row.paidLeaveDays} color="#1565c0" />
            <DataCell value={row.flexDays} color="#42a5f5" />
            <DataCell value={row.specialLeaveDays} color="#64b5f6" />
            <DataCell value={row.workingHours} align="right" />
          </Box>
        ))}
      </Box>

      {/* 合計行 */}
      <Box
        sx={{
          borderTop: '2px solid',
          borderColor: totalBorderColor,
          pt: 1,
          mt: 0.5,
        }}
      >
        <Box
          sx={{
            display: 'grid',
            gridTemplateColumns: GRID_COLS,
            gap: 1,
            bgcolor: totalBg,
            px: 1.5,
            py: 1,
            borderRadius: 0.5,
          }}
        >
          <DataCell value={totalRow.label} align="left" />
          <DataCell value={totalRow.businessDays} color="#757575" />
          <DataCell value={totalRow.workingDays} color="#1976d2" />
          <DataCell value={totalRow.paidLeaveDays} color="#1565c0" />
          <DataCell value={totalRow.flexDays} color="#42a5f5" />
          <DataCell value={totalRow.specialLeaveDays} color="#64b5f6" />
          <DataCell value={totalRow.workingHours} align="right" />
        </Box>
      </Box>
    </Box>
  )
}

export const WorkingHoursDetail = () => {
  const { data, loading, error } = useWorkingHours()
  const userName = useAuthStore((state) => state.user?.name ?? '')

  if (loading) {
    return (
      <Paper elevation={2} sx={{ p: 2 }}>
        <Skeleton variant="text" width={240} height={36} sx={{ mb: 2 }} />
        <Skeleton variant="rectangular" height={300} />
      </Paper>
    )
  }

  if (error) return <Alert severity="error">{error}</Alert>
  if (!data) return null

  return (
    <Paper elevation={2} sx={{ p: 2 }}>
      {/* セクションタイトル */}
      <Box sx={{ mb: 3 }}>
        <Typography variant="h6" fontWeight="medium">
          稼働時間詳細 - {userName}
        </Typography>
      </Box>

      <Box sx={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 3 }}>
        <WorkingHoursPanel
          title="過去6ヶ月（実績）"
          entries={data.actual.entries}
          summary={data.actual.summary}
          variant="actual"
        />
        <WorkingHoursPanel
          title="将来6ヶ月（見込）"
          entries={data.forecast.entries}
          summary={data.forecast.summary}
          variant="forecast"
        />
      </Box>
    </Paper>
  )
}
