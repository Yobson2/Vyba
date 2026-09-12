import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { EditorialItem, editorialListSchema } from '../data/schema'

export const editorialQueryKey = ['feed', 'editorial'] as const

export function useEditorialListQuery() {
  return useQuery({
    queryKey: editorialQueryKey,
    queryFn: async () => {
      const res = await api.get<unknown>(ENDPOINTS.FEED.ADMIN_LIST, {
        params: { type: 'EDITORIAL' },
      })
      return editorialListSchema.parse(res.data)
    },
  })
}

export interface CreateEditorialPayload {
  title: string
  body: string
  publishedAt?: string
  expiresAt: string
  venueId?: string
  draft?: boolean
}

export function useCreateEditorialMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (payload: CreateEditorialPayload) => {
      const res = await api.post<EditorialItem>(
        ENDPOINTS.FEED.EDITORIAL,
        payload
      )
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}

export interface UpdateEditorialPayload {
  id: string
  title?: string
  body?: string
  publishedAt?: string
  expiresAt?: string
  venueId?: string | null
}

export function useUpdateEditorialMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...payload }: UpdateEditorialPayload) => {
      const res = await api.patch<EditorialItem>(
        ENDPOINTS.FEED.EDITORIAL_DETAIL(id),
        payload
      )
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}

export function usePublishFeedItemMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.patch<EditorialItem>(ENDPOINTS.FEED.PUBLISH(id))
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}

export function useHideFeedItemMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.patch<EditorialItem>(ENDPOINTS.FEED.HIDE(id))
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}

export function useUnhideFeedItemMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.patch<EditorialItem>(ENDPOINTS.FEED.UNHIDE(id))
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}

export function useDeleteFeedItemMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(ENDPOINTS.FEED.DETAIL(id))
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: editorialQueryKey })
    },
  })
}
