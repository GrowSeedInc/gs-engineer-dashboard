import { apiClient } from '@/infrastructure/apiClient'

export const authRepository = {
  signIn: (email: string, password: string) =>
    apiClient.api.v1.auth.sign_in.$post({ body: { email, password } }),

  signOut: () =>
    apiClient.api.v1.auth.sign_out.$delete(),

  switchUser: (userId: number) =>
    apiClient.api.v1.auth.switch.$post({ body: { user_id: userId } }),
}
