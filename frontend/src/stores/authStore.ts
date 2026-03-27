import { create } from 'zustand'
import { persist } from 'zustand/middleware'

type AuthUser = {
  id: number
  email: string
  name: string
  token: string
}

type AuthState = {
  user: AuthUser | null
  setUser: (user: AuthUser) => void
  clearUser: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      setUser: (user) => set({ user }),
      clearUser: () => set({ user: null }),
    }),
    { name: 'auth-storage' },
  ),
)
