import { useQuery } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { monitorListSchema } from '../data/schema'

export const monitorQueryKey = ['insights', 'monitor', 'tonight'] as const

/** Manual refresh + a modest poll while the view is open (spec 18) — no websockets. */
const POLL_INTERVAL_MS = 60_000

export function useTonightMonitorQuery() {
  return useQuery({
    queryKey: monitorQueryKey,
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.MONITOR_TONIGHT)
      return monitorListSchema.parse(res.data)
    },
    refetchInterval: POLL_INTERVAL_MS,
  })
}
