import { apiClient } from '@/infrastructure/apiClient'

export const usersRepository = {
  getAll: () => apiClient.api.v1.users.$get(),
}
