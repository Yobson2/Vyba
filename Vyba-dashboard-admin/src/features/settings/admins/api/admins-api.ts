import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { Admin, adminListSchema } from '../data/schema'

export const adminsQueryKey = ['admins'] as const

export function useAdminsQuery() {
  return useQuery({
    queryKey: adminsQueryKey,
    queryFn: async () => {
      const res = await api.get<Admin[]>(ENDPOINTS.ADMINS.LIST)
      return adminListSchema.parse(res.data)
    },
  })
}

export interface CreateAdminPayload {
  email: string
  firstName?: string
  lastName?: string
}

export interface CreateAdminResult extends Admin {
  temporaryPassword: string
}

export function useCreateAdminMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (payload: CreateAdminPayload) => {
      const res = await api.post<CreateAdminResult>(
        ENDPOINTS.ADMINS.CREATE,
        payload
      )
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: adminsQueryKey })
    },
  })
}

export interface UpdateAdminPayload {
  id: string
  firstName?: string
  lastName?: string
  isActive?: boolean
}

export function useUpdateAdminMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...payload }: UpdateAdminPayload) => {
      const res = await api.patch<Admin>(ENDPOINTS.ADMINS.DETAIL(id), payload)
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: adminsQueryKey })
    },
  })
}

export function useResetAdminPasswordMutation() {
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.post<{ temporaryPassword: string }>(
        ENDPOINTS.ADMINS.RESET_PASSWORD(id)
      )
      return res.data
    },
  })
}
