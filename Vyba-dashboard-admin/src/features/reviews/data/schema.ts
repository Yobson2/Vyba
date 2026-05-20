import { z } from 'zod'

const reviewSchema = z.object({
  id: z.string(),
  userName: z.string(),
  userEmail: z.string(),
  venueName: z.string(),
  rating: z.number(),
  text: z.string(),
  isFlagged: z.boolean(),
  isHidden: z.boolean(),
  createdAt: z.coerce.date(),
})
export type Review = z.infer<typeof reviewSchema>

export const reviewListSchema = z.array(reviewSchema)
