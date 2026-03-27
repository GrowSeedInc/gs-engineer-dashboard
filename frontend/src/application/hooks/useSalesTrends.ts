import { useState, useEffect } from 'react'
import type { SalesTrendList } from '@domain/api/@types'
import { salesTrendsRepository } from '@/infrastructure/repositories/salesTrendsRepository'

type State = {
  data: SalesTrendList | null
  loading: boolean
  error: string | null
}

export const useSalesTrends = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    salesTrendsRepository
      .getTrends()
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
