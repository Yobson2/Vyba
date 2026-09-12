import { z } from 'zod'

const feedItemStatusSchema = z.union([
  z.literal('DRAFT'),
  z.literal('PUBLISHED'),
  z.literal('HIDDEN'),
  z.literal('EXPIRED'),
])
export type FeedItemStatus = z.infer<typeof feedItemStatusSchema>

const editorialPayloadSchema = z.object({
  title: z.string(),
  body: z.string(),
})

const editorialItemSchema = z.object({
  id: z.string(),
  type: z.literal('EDITORIAL'),
  venueId: z.string().nullable(),
  status: feedItemStatusSchema,
  publishedAt: z.coerce.date(),
  expiresAt: z.coerce.date().nullable(),
  payload: editorialPayloadSchema,
  createdAt: z.coerce.date(),
})
export type EditorialItem = z.infer<typeof editorialItemSchema>

export const editorialListSchema = z.array(editorialItemSchema)

/** Derived, display-only status — "expired" isn't stored, it's computed from the read filter (spec 03). */
export type DisplayStatus =
  | 'draft'
  | 'scheduled'
  | 'published'
  | 'expired'
  | 'hidden'

export function displayStatus(item: EditorialItem): DisplayStatus {
  if (item.status === 'DRAFT') return 'draft'
  if (item.status === 'HIDDEN') return 'hidden'
  if (item.expiresAt && item.expiresAt.getTime() < Date.now()) return 'expired'
  if (item.publishedAt.getTime() > Date.now()) return 'scheduled'
  return 'published'
}
