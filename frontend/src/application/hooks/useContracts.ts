import { useState, useEffect } from 'react'
import type { ContractList } from '@domain/api/@types'
import { contractsRepository } from '@/infrastructure/repositories/contractsRepository'

type State = {
  data: ContractList | null
  loading: boolean
  error: string | null
}

export const useContracts = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    contractsRepository
      .getContracts()
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
