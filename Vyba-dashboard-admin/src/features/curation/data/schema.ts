import { z } from 'zod'

export const mediaAssetStatusSchema = z.union([
  z.literal('active'),
  z.literal('hidden'),
  z.literal('deleted'),
])
export type MediaAssetStatus = z.infer<typeof mediaAssetStatusSchema>

const curationQueueItemSchema = z.object({
  id: z.string(),
  url: z.string(),
  thumbnailUrl: z.string(),
  venueId: z.string(),
  venueNightId: z.string().nullable(),
  venueNightDate: z.string().nullable(),
  uploadedByUserId: z.string(),
  status: mediaAssetStatusSchema,
  feedPromoted: z.boolean(),
  createdAt: z.coerce.date(),
})
export type CurationQueueItem = z.infer<typeof curationQueueItemSchema>

export const curationQueueListSchema = z.array(curationQueueItemSchema)
