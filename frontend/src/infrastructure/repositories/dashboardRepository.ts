import { apiClient } from '@/infrastructure/apiClient'

export const dashboardRepository = {
  getSummary: () =>
    apiClient.api.v1.dashboard.$get(),
}
