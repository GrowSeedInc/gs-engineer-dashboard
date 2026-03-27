import { Box } from '@mui/material'
import { MainLayout } from '@/presentation/layouts/MainLayout'
import { SummaryCards } from '@/presentation/components/SummaryCards'
import { SalesTrendChart } from '@/presentation/components/SalesTrendChart'
import { ReturnRateTrendChart } from '@/presentation/components/ReturnRateTrendChart'
import { ContractTimeline } from '@/presentation/components/ContractTimeline'
import { WorkingHoursDetail } from '@/presentation/components/WorkingHoursDetail'

export const DashboardPage = () => (
  <MainLayout>
    <Box sx={{ px: 3, py: 4, display: 'flex', flexDirection: 'column', gap: 3 }}>
      <SummaryCards />

      <Box sx={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 3 }}>
        <SalesTrendChart />
        <ReturnRateTrendChart />
      </Box>

      <ContractTimeline />

      <WorkingHoursDetail />
    </Box>
  </MainLayout>
)
