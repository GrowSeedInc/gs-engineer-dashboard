import { Box, Paper, Typography, Skeleton, Alert } from '@mui/material'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts'
import { useReturnRateTrends } from '@/application/hooks/useReturnRateTrends'
import { useAuthStore } from '@/stores/authStore'
import { formatYearMonth } from '@/shared/formatters'

export const ReturnRateTrendChart = () => {
  const { data, loading, error } = useReturnRateTrends()
  const userName = useAuthStore((state) => state.user?.name ?? '')

  const chartData = data?.trends?.map((t) => ({
    month: formatYearMonth(t.month),
    returnRate: t.return_rate ?? null,
  }))

  return (
    <Paper elevation={2} sx={{ p: 2, height: '100%', display: 'flex', flexDirection: 'column' }}>
      <Typography variant="h6" fontWeight="medium" sx={{ mb: 2 }}>
        還元率推移 - {userName}
      </Typography>

      {loading && <Skeleton variant="rectangular" height={300} />}

      {error && <Alert severity="error">{error}</Alert>}

      {chartData && (
        <>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart
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
                domain={[0, 100]}
                tickFormatter={(v: number) => `${v}%`}
                tick={{ fontSize: 12, fill: '#666' }}
              />
              <Tooltip
                formatter={(value) => typeof value === 'number' ? [`${value.toFixed(1)}%`, '還元率'] : ['', '還元率']}
                labelStyle={{ color: '#212121' }}
              />
              <Line
                type="monotone"
                dataKey="returnRate"
                name="還元率"
                stroke="#1976d2"
                strokeWidth={2}
                dot={{ r: 4, fill: '#1976d2' }}
                connectNulls={false}
              />
            </LineChart>
          </ResponsiveContainer>
          <Box sx={{ display: 'flex', justifyContent: 'center', gap: 3, mt: 1 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
              <Box sx={{ width: 12, height: 2, bgcolor: '#1976d2' }} />
              <Typography variant="caption" color="text.secondary">還元率</Typography>
            </Box>
          </Box>
        </>
      )}

      <Box sx={{ mt: 'auto', pt: 1.5, px: 1.5, py: 1.5, bgcolor: 'grey.50', borderRadius: 1 }}>
        <Typography variant="body2" color="text.secondary">
          還元率 = 月額給与 ÷ 月額単価(税抜)
        </Typography>
      </Box>
    </Paper>
  )
}
