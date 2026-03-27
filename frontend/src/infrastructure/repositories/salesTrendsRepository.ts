import { apiClient } from '@/infrastructure/apiClient'

export const salesTrendsRepository = {
  getTrends: (query?: { from?: string; to?: string }) =>
    apiClient.api.v1.sales_trends.$get({ query }),
}
