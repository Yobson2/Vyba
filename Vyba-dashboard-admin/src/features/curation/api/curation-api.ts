import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import {
  CurationQueueItem,
  curationQueueListSchema,
  MediaAssetStatus,
} from '../data/schema'

export const curationQueueKey = ['media', 'curation'] as const

export interface CurationQueueParams {
  status?: MediaAssetStatus
  venueId?: string
}

export function useCurationQueueQuery(params: CurationQueueParams = {}) {
  return useQuery({
    queryKey: [...curationQueueKey, params],
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.MEDIA.ADMIN_LIST, {
        params,
      })
      return curationQueueListSchema.parse(res.data)
    },
  })
}

export function usePromotePhotoMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.patch<CurationQueueItem>(
        ENDPOINTS.MEDIA.PROMOTE(id)
      )
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: curationQueueKey })
    },
  })
}

export function useHidePhotoMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.patch<CurationQueueItem>(ENDPOINTS.MEDIA.HIDE(id))
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: curationQueueKey })
    },
  })
}

export function useDeletePhotoMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(ENDPOINTS.MEDIA.DELETE(id))
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: curationQueueKey })
    },
  })
}
