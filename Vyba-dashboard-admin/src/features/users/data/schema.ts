import { z } from 'zod'

const userStatusSchema = z.union([
  z.literal('active'),
  z.literal('inactive'),
  z.literal('suspended'),
  z.literal('banned'),
])
export type UserStatus = z.infer<typeof userStatusSchema>

const userRoleSchema = z.union([
  z.literal('client'),
  z.literal('venue_owner'),
])
export type UserRole = z.infer<typeof userRoleSchema>

const userSchema = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string(),
  phone: z.string(),
  avatarUrl: z.string().nullable(),
  role: userRoleSchema,
  status: userStatusSchema,
  city: z.string(),
  bookingCount: z.number(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type User = z.infer<typeof userSchema>

export const userListSchema = z.array(userSchema)
