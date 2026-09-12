import { z } from 'zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'

const organicVsAssistedSchema = z.object({
  organic: z.number(),
  assisted: z.number(),
})
export type OrganicVsAssisted = z.infer<typeof organicVsAssistedSchema>

export function organicVsAssistedQueryKey(venueId: string) {
  return ['metrics', 'organic-vs-assisted', venueId] as const
}

export function useOrganicVsAssistedQuery(venueId: string | undefined) {
  return useQuery({
    queryKey: organicVsAssistedQueryKey(venueId ?? ''),
    queryFn: async () => {
      const res = await api.get<unknown>(
        ENDPOINTS.METRICS.ORGANIC_VS_ASSISTED(venueId!)
      )
      return organicVsAssistedSchema.parse(res.data)
    },
    enabled: !!venueId,
  })
}

export interface CreateAssistedPromoPayload {
  venueId: string
  title: string
  description: string
}

export function useCreateAssistedPromoMutation() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ venueId, ...payload }: CreateAssistedPromoPayload) => {
      const res = await api.post(ENDPOINTS.FEED.ASSIST_PROMO(venueId), payload)
      return res.data
    },
    onSuccess: (_data, variables) => {
      void queryClient.invalidateQueries({
        queryKey: organicVsAssistedQueryKey(variables.venueId),
      })
    },
  })
}
