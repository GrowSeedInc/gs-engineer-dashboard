import { apiClient } from '@/infrastructure/apiClient'

export const returnRateTrendsRepository = {
  getTrends: (query?: { from?: string; to?: string }) =>
    apiClient.api.v1.return_rate_trends.$get({ query }),
}
