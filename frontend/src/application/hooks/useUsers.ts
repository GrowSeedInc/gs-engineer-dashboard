import { useEffect, useState } from 'react'
import { usersRepository } from '@/infrastructure/repositories/usersRepository'
import type * as Types from '@domain/api/@types'

export const useUsers = () => {
  const [users, setUsers] = useState<Types.User[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    usersRepository
      .getAll()
      .then(setUsers)
      .finally(() => setLoading(false))
  }, [])

  return { users, loading }
}
