import { useState, useEffect } from 'react'
import type { WorkingHoursDetail } from '@domain/api/@types'
import { workingHoursRepository } from '@/infrastructure/repositories/workingHoursRepository'

type State = {
  data: WorkingHoursDetail | null
  loading: boolean
  error: string | null
}

export const useWorkingHours = () => {
  const [state, setState] = useState<State>({ data: null, loading: true, error: null })

  useEffect(() => {
    workingHoursRepository
      .getWorkingHours()
      .then((data) => setState({ data, loading: false, error: null }))
      .catch(() =>
        setState({ data: null, loading: false, error: 'データの取得に失敗しました' }),
      )
  }, [])

  return state
}
