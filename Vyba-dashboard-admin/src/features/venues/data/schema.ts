import { z } from 'zod'

const venueStatusSchema = z.union([
  z.literal('active'),
  z.literal('pending'),
  z.literal('suspended'),
  z.literal('rejected'),
])
export type VenueStatus = z.infer<typeof venueStatusSchema>

const venueTypeSchema = z.union([
  z.literal('club'),
  z.literal('bar'),
  z.literal('lounge'),
  z.literal('restaurant'),
  z.literal('rooftop'),
  z.literal('beach_club'),
  z.literal('maquis'),
])
export type VenueType = z.infer<typeof venueTypeSchema>

const priceLevelSchema = z.union([
  z.literal(1),
  z.literal(2),
  z.literal(3),
  z.literal(4),
])
export type PriceLevel = z.infer<typeof priceLevelSchema>

const venueSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string(),
  address: z.string(),
  venueType: venueTypeSchema,
  priceLevel: priceLevelSchema,
  rating: z.number(),
  reviewCount: z.number(),
  isOpen: z.boolean(),
  isPremium: z.boolean(),
  status: venueStatusSchema,
  ownerName: z.string(),
  city: z.string(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type Venue = z.infer<typeof venueSchema>

export const venueListSchema = z.array(venueSchema)
