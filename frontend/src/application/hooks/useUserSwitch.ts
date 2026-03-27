import { useState } from 'react'
import { authRepository } from '@/infrastructure/repositories/authRepository'
import { useAuthStore } from '@/stores/authStore'

export const useUserSwitch = () => {
  const [loading, setLoading] = useState(false)
  const setUser = useAuthStore((state) => state.setUser)
  const currentUser = useAuthStore((state) => state.user)

  const switchUser = async (userId: number) => {
    if (userId === currentUser?.id) return
    setLoading(true)
    try {
      const { token, user } = await authRepository.switchUser(userId)
      setUser({ id: user.id, email: user.email, name: user.name, token })
      window.location.reload()
    } finally {
      setLoading(false)
    }
  }

  return { switchUser, loading }
}
