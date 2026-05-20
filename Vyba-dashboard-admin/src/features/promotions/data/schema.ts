import { z } from 'zod'

const promoStatusSchema = z.union([
  z.literal('active'),
  z.literal('scheduled'),
  z.literal('expired'),
  z.literal('pending'),
  z.literal('rejected'),
])
export type PromoStatus = z.infer<typeof promoStatusSchema>

const promoTypeSchema = z.union([
  z.literal('happy_hour'),
  z.literal('event'),
  z.literal('discount'),
])
export type PromoType = z.infer<typeof promoTypeSchema>

const promotionSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string(),
  venueName: z.string(),
  promoType: promoTypeSchema,
  startDate: z.coerce.date(),
  endDate: z.coerce.date(),
  isPremiumBoosted: z.boolean(),
  status: promoStatusSchema,
  createdAt: z.coerce.date(),
})
export type Promotion = z.infer<typeof promotionSchema>

export const promotionListSchema = z.array(promotionSchema)
