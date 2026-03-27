import { useState } from 'react'
import {
  AppBar,
  Toolbar,
  Box,
  Typography,
  Menu,
  MenuItem,
  CircularProgress,
} from '@mui/material'
import BarChartIcon from '@mui/icons-material/BarChart'
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown'
import { useAuthStore } from '@/stores/authStore'
import { useSignOut } from '@/application/hooks/useSignOut'

export const Header = () => {
  const user = useAuthStore((state) => state.user)
  const { signOut, loading } = useSignOut()
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null)

  const handleOpen = (e: React.MouseEvent<HTMLElement>) => setAnchorEl(e.currentTarget)
  const handleClose = () => setAnchorEl(null)
  const handleSignOut = async () => {
    handleClose()
    await signOut()
  }

  return (
    <AppBar position="fixed" color="inherit" elevation={2} sx={{ bgcolor: 'white' }}>
      <Toolbar>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, flexGrow: 1 }}>
          <BarChartIcon color="primary" sx={{ fontSize: 32 }} />
          <Typography variant="h6" fontWeight="medium" color="text.primary">
            エンジニアダッシュボード
          </Typography>
        </Box>

        <Box
          onClick={handleOpen}
          sx={{
            display: 'flex',
            alignItems: 'center',
            border: '1px solid',
            borderColor: 'grey.300',
            borderRadius: 1,
            px: 1.75,
            py: 0.75,
            cursor: 'pointer',
            minWidth: 160,
            userSelect: 'none',
            '&:hover': { bgcolor: 'grey.50' },
          }}
        >
          <Typography variant="body1" sx={{ flexGrow: 1 }}>
            {user?.name}
          </Typography>
          {loading ? (
            <CircularProgress size={16} />
          ) : (
            <ArrowDropDownIcon sx={{ color: 'text.secondary' }} />
          )}
        </Box>

        <Menu
          anchorEl={anchorEl}
          open={!!anchorEl}
          onClose={handleClose}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
          transformOrigin={{ vertical: 'top', horizontal: 'right' }}
        >
          <MenuItem onClick={handleSignOut} disabled={loading}>
            ログアウト
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  )
}
