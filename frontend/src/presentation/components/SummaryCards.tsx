import { Box, Paper, Typography, Skeleton } from '@mui/material'
import AttachMoneyIcon from '@mui/icons-material/AttachMoney'
import TrendingUpIcon from '@mui/icons-material/TrendingUp'
import PercentIcon from '@mui/icons-material/Percent'
import { useDashboardSummary } from '@/application/hooks/useDashboardSummary'

const formatCurrency = (value: number) => `¥${value.toLocaleString('ja-JP')}`
const formatPercent = (value: number) => `${value.toFixed(1)}%`

type SummaryCardProps = {
  label: string
  value: string | null
  loading: boolean
  iconBg: string
  icon: React.ReactNode
}

const SummaryCard = ({ label, value, loading, iconBg, icon }: SummaryCardProps) => (
  <Paper
    elevation={2}
    sx={{ flex: 1, p: 2, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}
  >
    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
      <Typography variant="body2" color="text.secondary">
        {label}
      </Typography>
      {loading ? (
        <Skeleton width={120} height={36} />
      ) : (
        <Typography variant="h5">{value}</Typography>
      )}
    </Box>
    <Box
      sx={{
        width: 56,
        height: 56,
        borderRadius: '50%',
        bgcolor: iconBg,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: 'white',
        flexShrink: 0,
      }}
    >
      {icon}
    </Box>
  </Paper>
)

export const SummaryCards = () => {
  const { data, loading } = useDashboardSummary()

  return (
    <Box sx={{ display: 'flex', gap: 3 }}>
      <SummaryCard
        label="月額給与"
        value={data ? formatCurrency(data.monthly_salary) : null}
        loading={loading}
        iconBg="#42a5f5"
        icon={<AttachMoneyIcon sx={{ fontSize: 32 }} />}
      />
      <SummaryCard
        label="月額単価（税抜）"
        value={data ? formatCurrency(data.monthly_unit_price) : null}
        loading={loading}
        iconBg="#1976d2"
        icon={<TrendingUpIcon sx={{ fontSize: 32 }} />}
      />
      <SummaryCard
        label="還元率"
        value={data ? formatPercent(data.return_rate) : null}
        loading={loading}
        iconBg="#64b5f6"
        icon={<PercentIcon sx={{ fontSize: 32 }} />}
      />
    </Box>
  )
}
