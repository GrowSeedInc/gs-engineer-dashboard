import { createTheme, ThemeProvider, CssBaseline } from '@mui/material'
import { useAuthStore } from '@/stores/authStore'
import { LoginPage } from '@/presentation/pages/LoginPage'
import { DashboardPage } from '@/presentation/pages/DashboardPage'

const theme = createTheme({
  palette: {
    primary: { main: '#1976d2' },
    secondary: { main: '#42a5f5' },
    background: { default: '#f5f5f5' },
  },
})

export const App = () => {
  const user = useAuthStore((state) => state.user)

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      {user ? <DashboardPage /> : <LoginPage />}
    </ThemeProvider>
  )
}
