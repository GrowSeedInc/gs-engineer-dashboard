import { useState } from 'react'
import { authRepository } from '@/infrastructure/repositories/authRepository'
import { useAuthStore } from '@/stores/authStore'

export const useSignOut = () => {
  const [loading, setLoading] = useState(false)
  const clearUser = useAuthStore((state) => state.clearUser)

  const signOut = async () => {
    setLoading(true)
    try {
      await authRepository.signOut()
    } finally {
      clearUser()
      setLoading(false)
    }
  }

  return { signOut, loading }
}
