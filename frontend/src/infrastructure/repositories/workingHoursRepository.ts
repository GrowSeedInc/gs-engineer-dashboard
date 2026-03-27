import { apiClient } from '@/infrastructure/apiClient'

export const workingHoursRepository = {
  getWorkingHours: () =>
    apiClient.api.v1.working_hours.$get(),
}
