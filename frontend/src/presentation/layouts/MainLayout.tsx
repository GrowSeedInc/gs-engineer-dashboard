import { Box } from '@mui/material'
import { Header } from '@/presentation/components/Header'

type Props = {
  children: React.ReactNode
}

export const MainLayout = ({ children }: Props) => (
  <Box sx={{ minHeight: '100vh', bgcolor: 'background.default' }}>
    <Header />
    <Box component="main" sx={{ pt: '64px' }}>
      {children}
    </Box>
  </Box>
)
