import { useMemo } from 'react'
import { Box, Paper, Typography, Skeleton, Alert } from '@mui/material'
import CheckCircleOutlineIcon from '@mui/icons-material/CheckCircleOutline'
import RadioButtonUncheckedIcon from '@mui/icons-material/RadioButtonUnchecked'
import type { Contract } from '@domain/api/@types'
import { useContracts } from '@/application/hooks/useContracts'
import { formatYearMonth } from '@/shared/formatters'

const getCurrentYearMonth = (): string => {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`
}

const formatMonthHeader = (yyyyMM: string): string => {
  const [year, month] = yyyyMM.split('-')
  return `${year}/${Number(month)}`
}

type CellStatus = 'ordered' | 'unordered' | 'empty'

const getCellStatus = (contract: Contract, month: string): CellStatus => {
  const status = contract.monthly_statuses.find((s) => s.month === month)
  if (!status) return 'empty'
  return status.is_ordered ? 'ordered' : 'unordered'
}

const ContractCell = ({ status }: { status: CellStatus }) => {
  if (status === 'empty') {
    return (
      <Box
        sx={{
          border: '2px solid',
          borderColor: 'grey.300',
          borderRadius: 0.5,
          bgcolor: 'white',
          height: 48,
        }}
      />
    )
  }
  const isOrdered = status === 'ordered'
  return (
    <Box
      sx={{
        border: '2px solid',
        borderColor: isOrdered ? '#1976d2' : '#42a5f5',
        bgcolor: isOrdered ? 'rgba(25,118,210,0.08)' : 'rgba(100,181,246,0.08)',
        borderRadius: 0.5,
        height: 48,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      {isOrdered ? (
        <CheckCircleOutlineIcon sx={{ fontSize: 20, color: '#1976d2' }} />
      ) : (
        <RadioButtonUncheckedIcon sx={{ fontSize: 20, color: '#42a5f5' }} />
      )}
    </Box>
  )
}

export const ContractTimeline = () => {
  const { data, loading, error } = useContracts()
  const currentYearMonth = useMemo(() => getCurrentYearMonth(), [])

  if (loading) {
    return (
      <Paper elevation={2} sx={{ p: 2 }}>
        <Skeleton variant="text" width={200} height={36} sx={{ mb: 2 }} />
        <Skeleton variant="rectangular" height={400} />
      </Paper>
    )
  }

  if (error) return <Alert severity="error">{error}</Alert>
  if (!data) return null

  const { display_months, contracts } = data
  const gridTemplateColumns = `repeat(${display_months.length}, 1fr)`

  return (
    <Paper elevation={2} sx={{ p: 2 }}>
      <Typography variant="h6" fontWeight="medium" sx={{ mb: 2 }}>
        受注契約情報（時系列）
      </Typography>

      <Box sx={{ overflowX: 'auto' }}>
        {/* 月ヘッダー */}
        <Box sx={{ display: 'grid', gridTemplateColumns, gap: 1 }}>
          {display_months.map((month) => {
            const isActual = month < currentYearMonth
            return (
              <Box
                key={month}
                sx={{
                  bgcolor: isActual ? '#42a5f5' : '#eeeeee',
                  borderBottom: '3px solid',
                  borderColor: isActual ? '#1976d2' : '#bdbdbd',
                  borderRadius: '8px 8px 0 0',
                  px: 1,
                  py: 1,
                  textAlign: 'center',
                  minWidth: 80,
                }}
              >
                <Typography variant="caption" display="block" fontWeight="medium">
                  {formatMonthHeader(month)}
                </Typography>
                <Typography variant="caption" color="text.secondary" display="block">
                  {isActual ? '実績' : '予定'}
                </Typography>
              </Box>
            )
          })}
        </Box>

        {/* 契約行 */}
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1, mt: 1 }}>
          {contracts.map((contract) => {
            const hasStarted = contract.period_start <= currentYearMonth
            return (
              <Box key={contract.id}>
                <Box sx={{ display: 'grid', gridTemplateColumns, gap: 1 }}>
                  {display_months.map((month) => (
                    <ContractCell key={month} status={getCellStatus(contract, month)} />
                  ))}
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75, mt: 0.5, px: 1 }}>
                  {hasStarted ? (
                    <CheckCircleOutlineIcon sx={{ fontSize: 18, color: '#1976d2', flexShrink: 0 }} />
                  ) : (
                    <RadioButtonUncheckedIcon sx={{ fontSize: 18, color: '#64b5f6', flexShrink: 0 }} />
                  )}
                  <Typography variant="body2" sx={{ flexGrow: 1 }}>
                    {contract.name} - ¥{contract.unit_price.toLocaleString('ja-JP')}
                  </Typography>
                  <Typography variant="caption" color="text.secondary" sx={{ whiteSpace: 'nowrap' }}>
                    {formatYearMonth(contract.period_start)} 〜 {formatYearMonth(contract.period_end)}
                  </Typography>
                </Box>
              </Box>
            )
          })}
        </Box>

        {/* 凡例 */}
        <Box sx={{ display: 'flex', justifyContent: 'center', gap: 3, mt: 3 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box
              sx={{
                border: '2px solid #1976d2',
                borderRadius: 0.5,
                p: 0.5,
                bgcolor: 'rgba(25,118,210,0.08)',
                display: 'flex',
              }}
            >
              <CheckCircleOutlineIcon sx={{ fontSize: 18, color: '#1976d2' }} />
            </Box>
            <Typography variant="body2">受注済み</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box
              sx={{
                border: '2px solid #42a5f5',
                borderRadius: 0.5,
                p: 0.5,
                bgcolor: 'rgba(100,181,246,0.08)',
                display: 'flex',
              }}
            >
              <RadioButtonUncheckedIcon sx={{ fontSize: 18, color: '#42a5f5' }} />
            </Box>
            <Typography variant="body2">未受注</Typography>
          </Box>
        </Box>
      </Box>
    </Paper>
  )
}
