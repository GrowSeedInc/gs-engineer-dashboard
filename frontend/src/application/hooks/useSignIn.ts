import { useState } from 'react'
import { authRepository } from '@/infrastructure/repositories/authRepository'
import { useAuthStore } from '@/stores/authStore'

export const useSignIn = () => {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const setUser = useAuthStore((state) => state.setUser)

  const signIn = async (email: string, password: string) => {
    setLoading(true)
    setError(null)
    try {
      const { token, user } = await authRepository.signIn(email, password)
      setUser({ id: user.id, email: user.email, name: user.name, token })
    } catch {
      setError('メールアドレスまたはパスワードが正しくありません')
    } finally {
      setLoading(false)
    }
  }

  return { signIn, loading, error }
}
