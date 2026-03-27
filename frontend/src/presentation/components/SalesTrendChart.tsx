import { Box, Paper, Typography, Skeleton, Alert } from '@mui/material'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts'
import { useSalesTrends } from '@/application/hooks/useSalesTrends'
import { useAuthStore } from '@/stores/authStore'
import { formatYearMonth, formatCurrency } from '@/shared/formatters'

export const SalesTrendChart = () => {
  const { data, loading, error } = useSalesTrends()
  const userName = useAuthStore((state) => state.user?.name ?? '')

  const chartData = data?.trends?.map((t) => ({
    month: formatYearMonth(t.month),
    actual: t.actual_amount ?? null,
    forecast: t.forecast_amount ?? null,
  }))

  return (
    <Paper elevation={2} sx={{ p: 2, height: '100%' }}>
      <Typography variant="h6" fontWeight="medium" sx={{ mb: 2 }}>
        売上推移 - {userName}
      </Typography>

      {loading && <Skeleton variant="rectangular" height={300} />}

      {error && <Alert severity="error">{error}</Alert>}

      {chartData && (
        <>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart
              data={chartData}
              margin={{ top: 5, right: 5, bottom: 60, left: 20 }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis
                dataKey="month"
                tick={{ fontSize: 12, fill: '#666' }}
                angle={-45}
                textAnchor="end"
                interval={0}
              />
              <YAxis
                tickFormatter={(v: number) => `¥${(v / 10000).toFixed(0)}万`}
                tick={{ fontSize: 12, fill: '#666' }}
              />
              <Tooltip
                formatter={(value) => typeof value === 'number' ? [formatCurrency(value), ''] : ['', '']}
                labelStyle={{ color: '#212121' }}
              />
              <Bar dataKey="actual" name="実績" fill="#1976d2" maxBarSize={40} />
              <Bar dataKey="forecast" name="予測" fill="#64b5f6" maxBarSize={40} />
            </BarChart>
          </ResponsiveContainer>
          <Box sx={{ display: 'flex', justifyContent: 'center', gap: 3, mt: 1 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
              <Box sx={{ width: 12, height: 12, bgcolor: '#64b5f6', borderRadius: 0.5 }} />
              <Typography variant="caption" color="text.secondary">予測</Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
              <Box sx={{ width: 12, height: 12, bgcolor: '#1976d2', borderRadius: 0.5 }} />
              <Typography variant="caption" color="text.secondary">実績</Typography>
            </Box>
          </Box>
        </>
      )}
    </Paper>
  )
}
