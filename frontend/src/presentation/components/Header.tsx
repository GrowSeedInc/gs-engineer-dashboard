import { useState } from 'react'
import {
  AppBar,
  Toolbar,
  Box,
  Typography,
  Menu,
  MenuItem,
  Divider,
  CircularProgress,
  ListItemText,
} from '@mui/material'
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown'
import { useAuthStore } from '@/stores/authStore'
import { useSignOut } from '@/application/hooks/useSignOut'
import { useUsers } from '@/application/hooks/useUsers'
import { useUserSwitch } from '@/application/hooks/useUserSwitch'

export const Header = () => {
  const user = useAuthStore((state) => state.user)
  const { signOut, loading: signOutLoading } = useSignOut()
  const { users } = useUsers()
  const { switchUser, loading: switchLoading } = useUserSwitch()
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null)

  const handleOpen = (e: React.MouseEvent<HTMLElement>) => setAnchorEl(e.currentTarget)
  const handleClose = () => setAnchorEl(null)

  const handleSignOut = async () => {
    handleClose()
    await signOut()
  }

  const handleSwitchUser = async (userId: number) => {
    handleClose()
    await switchUser(userId)
  }

  const loading = signOutLoading || switchLoading
  const otherUsers = users.filter((u) => u.id !== user?.id)

  return (
    <AppBar position="fixed" color="inherit" elevation={2} sx={{ bgcolor: 'white' }}>
      <Toolbar>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, flexGrow: 1 }}>
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="3" y="19" width="6" height="10" rx="1.5" fill="#1976d2"/>
            <rect x="13" y="11" width="6" height="18" rx="1.5" fill="#1976d2"/>
            <rect x="23" y="15" width="6" height="14" rx="1.5" fill="#1976d2"/>
            <polyline points="6,17 16,9 26,13" stroke="#42a5f5" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
          </svg>
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
            width: 200,
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
          slotProps={{ paper: { sx: { minWidth: 200 } } }}
        >
          {otherUsers.length > 0 && [
            <MenuItem key="label" disabled sx={{ opacity: '1 !important' }}>
              <Typography variant="caption" color="text.secondary">
                ユーザーを切り替え
              </Typography>
            </MenuItem>,
            ...otherUsers.map((u) => (
              <MenuItem key={u.id} onClick={() => handleSwitchUser(u.id)} disabled={loading}>
                <ListItemText primary={u.name} secondary={u.email} />
              </MenuItem>
            )),
            <Divider key="divider" />,
          ]}
          <MenuItem onClick={handleSignOut} disabled={loading}>
            ログアウト
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  )
}
