import { z } from 'zod'

const venueTypeSchema = z.union([
  z.literal('CLUB'),
  z.literal('BAR'),
  z.literal('LOUNGE'),
  z.literal('MAQUIS'),
])
export type VenueType = z.infer<typeof venueTypeSchema>

const validationStatusSchema = z.union([
  z.literal('ONBOARDING'),
  z.literal('ACTIVE'),
  z.literal('PAUSED'),
])
export type ValidationStatus = z.infer<typeof validationStatusSchema>

const priceLevelSchema = z.union([
  z.literal(1),
  z.literal(2),
  z.literal(3),
  z.literal(4),
])
export type PriceLevel = z.infer<typeof priceLevelSchema>

const venueOwnerSchema = z
  .object({
    id: z.string(),
    phone: z.string(),
    firstName: z.string().nullable(),
    lastName: z.string().nullable(),
  })
  .nullable()
export type VenueOwner = z.infer<typeof venueOwnerSchema>

const venueSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string().nullable(),
  address: z.string().nullable(),
  latitude: z.number(),
  longitude: z.number(),
  venueType: venueTypeSchema,
  priceLevel: priceLevelSchema,
  ownerUserId: z.string().nullable(),
  owner: venueOwnerSchema,
  validationStatus: validationStatusSchema,
  inLaunchArea: z.boolean(),
  isActive: z.boolean(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type Venue = z.infer<typeof venueSchema>

export const venueListSchema = z.array(venueSchema)
