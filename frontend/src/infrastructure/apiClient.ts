import axios from 'axios'
import aspida from '@aspida/axios'
import api from '@domain/api/$api'
import { useAuthStore } from '@/stores/authStore'

const axiosInstance = axios.create()

axiosInstance.interceptors.request.use((config) => {
  const token = useAuthStore.getState().user?.token
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export const apiClient = api(aspida(axiosInstance))
