import { z } from 'zod'
import { useQuery } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import {
  contentActivitySchema,
  goingPerNightSchema,
  organicPostingSchema,
  retentionReportSchema,
} from '../data/schema'

export const metricsQueryKey = ['insights', 'metrics'] as const

export function useZone4WauQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'zone4-wau'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.ZONE4_WAU)
      return z.object({ wau: z.number() }).parse(res.data).wau
    },
  })
}

export function useRetentionQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'retention'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.RETENTION)
      return retentionReportSchema.parse(res.data)
    },
  })
}

export function useOrganicPostingQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'organic-posting'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.ORGANIC_POSTING)
      return organicPostingSchema.parse(res.data)
    },
  })
}

export function useGoingPerNightQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'going-per-night'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.GOING_PER_NIGHT)
      return goingPerNightSchema.parse(res.data)
    },
  })
}

export function useActiveVenuesQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'active-venues'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.ACTIVE_VENUES)
      return z.object({ count: z.number() }).parse(res.data).count
    },
  })
}

export function useContentActivityQuery() {
  return useQuery({
    queryKey: [...metricsQueryKey, 'content-activity'],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.METRICS.CONTENT_ACTIVITY)
      return contentActivitySchema.parse(res.data)
    },
  })
}
