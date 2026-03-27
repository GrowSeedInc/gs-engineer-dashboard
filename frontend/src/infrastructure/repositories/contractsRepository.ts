import { apiClient } from '@/infrastructure/apiClient'

export const contractsRepository = {
  getContracts: (query?: { from?: string; to?: string }) =>
    apiClient.api.v1.contracts.$get({ query }),
}
