import { create } from 'zustand'

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

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  clearUser: () => set({ user: null }),
}))
