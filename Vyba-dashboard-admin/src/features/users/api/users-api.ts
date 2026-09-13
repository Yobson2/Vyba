import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { PaginatedResponse } from '@/api/types'
import { User, userListSchema } from '../data/schema'

export const usersQueryKey = ['users'] as const

export function useUsersQuery() {
  return useQuery({
    queryKey: usersQueryKey,
    queryFn: async () => {
      const res = await api.get<PaginatedResponse<User>>(ENDPOINTS.USERS.LIST, {
        params: { limit: 100 },
      })
      return userListSchema
        .parse(res.data.data)
        .filter((user) => user.role !== 'ADMIN')
    },
  })
}

export interface UpdateUserPayload {
  id: string
  isActive: boolean
}

/** Deactivate/reactivate a user (support/moderation) — same PATCH the backend already exposed. */
export function useUpdateUserMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...payload }: UpdateUserPayload) => {
      const res = await api.patch<User>(ENDPOINTS.USERS.DETAIL(id), payload)
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: usersQueryKey })
    },
  })
}
