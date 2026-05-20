import { z } from 'zod'

const bookingStatusSchema = z.union([
  z.literal('pending'),
  z.literal('confirmed'),
  z.literal('cancelled'),
  z.literal('completed'),
])
export type BookingStatus = z.infer<typeof bookingStatusSchema>

const bookingZoneSchema = z.union([
  z.literal('indoor_lounge'),
  z.literal('outdoor_terrace'),
  z.literal('vip_booth'),
])
export type BookingZone = z.infer<typeof bookingZoneSchema>

const bookingSchema = z.object({
  id: z.string(),
  reference: z.string(),
  guestName: z.string(),
  guestEmail: z.string(),
  venueName: z.string(),
  date: z.coerce.date(),
  timeSlot: z.string(),
  guestCount: z.number(),
  zone: bookingZoneSchema,
  status: bookingStatusSchema,
  depositAmount: z.number(),
  createdAt: z.coerce.date(),
})
export type Booking = z.infer<typeof bookingSchema>

export const bookingListSchema = z.array(bookingSchema)
