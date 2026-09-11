import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { PaginatedResponse } from '@/api/types'
import {
  Venue,
  ValidationStatus,
  VenueType,
  venueListSchema,
} from '../data/schema'

export const venuesQueryKey = ['venues'] as const

export function useVenuesQuery() {
  return useQuery({
    queryKey: venuesQueryKey,
    queryFn: async () => {
      const res = await api.get<PaginatedResponse<Venue>>(
        ENDPOINTS.VENUES.LIST,
        { params: { limit: 100 } }
      )
      return venueListSchema.parse(res.data.data)
    },
  })
}

export interface CreateVenuePayload {
  name: string
  description?: string
  address?: string
  latitude: number
  longitude: number
  venueType: VenueType
  priceLevel: number
}

export function useCreateVenueMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (payload: CreateVenuePayload) => {
      const res = await api.post<Venue>(ENDPOINTS.VENUES.LIST, payload)
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: venuesQueryKey })
    },
  })
}

export interface UpdateVenuePayload extends Partial<CreateVenuePayload> {
  id: string
  validationStatus?: ValidationStatus
}

export function useUpdateVenueMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...payload }: UpdateVenuePayload) => {
      const res = await api.patch<Venue>(ENDPOINTS.VENUES.DETAIL(id), payload)
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: venuesQueryKey })
    },
  })
}

export function useDeactivateVenueMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(ENDPOINTS.VENUES.DETAIL(id))
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: venuesQueryKey })
    },
  })
}

export interface BindOwnerPayload {
  id: string
  phone: string
  firstName?: string
  lastName?: string
}

export function useBindOwnerMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...payload }: BindOwnerPayload) => {
      const res = await api.post<Venue>(ENDPOINTS.VENUES.OWNER(id), payload)
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: venuesQueryKey })
    },
  })
}

export function useUnbindOwnerMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.delete<Venue>(ENDPOINTS.VENUES.OWNER(id))
      return res.data
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: venuesQueryKey })
    },
  })
}
