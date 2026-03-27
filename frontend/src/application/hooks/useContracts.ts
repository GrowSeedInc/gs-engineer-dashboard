import { useState, useEffect } from 'react'
import type { ContractList } from '@domain/api/@types'
import { contractsRepository } from '@/infrastructure/repositories/contractsRepository'

type State = {
  data: ContractList | null
  loading: boolean
  error: string | null
}

const getDateRange = () => {
  const now = new Date()
  const from = new Date(now.getFullYear(), now.getMonth() - 6, 1)
  const to = new Date(now.getFullYear(), now.getMonth() + 6, 1)
  const fmt = (d: Date) =>
    `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`
  return { from: fmt(from), to: fmt(to) }
}

export const useContracts = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    const { from, to } = getDateRange()
    contractsRepository
      .getContracts({ from, to })
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
