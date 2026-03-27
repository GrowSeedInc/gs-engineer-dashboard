import { useState, useEffect } from 'react'
import type { ReturnRateTrendList } from '@domain/api/@types'
import { returnRateTrendsRepository } from '@/infrastructure/repositories/returnRateTrendsRepository'

type State = {
  data: ReturnRateTrendList | null
  loading: boolean
  error: string | null
}

export const useReturnRateTrends = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    returnRateTrendsRepository
      .getTrends()
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
