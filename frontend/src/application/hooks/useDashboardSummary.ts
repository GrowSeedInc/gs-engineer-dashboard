import { useState, useEffect } from 'react'
import type { DashboardSummary } from '@domain/api/@types'
import { dashboardRepository } from '@/infrastructure/repositories/dashboardRepository'

type State = {
  data: DashboardSummary | null
  loading: boolean
  error: string | null
}

export const useDashboardSummary = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    dashboardRepository
      .getSummary()
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
