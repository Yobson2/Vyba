import { z } from 'zod'

const userStatusSchema = z.union([
  z.literal('active'),
  z.literal('inactive'),
  z.literal('suspended'),
  z.literal('banned'),
])
export type UserStatus = z.infer<typeof userStatusSchema>

// App users are clients or venue owners. Team members (ADMIN) live in settings/admins.
const userRoleSchema = z.union([
  z.literal('CLIENT'),
  z.literal('VENUE_OWNER'),
])
export type UserRole = z.infer<typeof userRoleSchema>

const acquisitionSourceSchema = z.union([
  z.literal('qr'),
  z.literal('web'),
  z.literal('referral'),
  z.literal('organic'),
  z.literal('campaign'),
])
export type AcquisitionSource = z.infer<typeof acquisitionSourceSchema>

const userSchema = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string(),
  phone: z.string(),
  avatarUrl: z.string().nullable(),
  role: userRoleSchema,
  status: userStatusSchema,
  city: z.string(),
  acquisitionSource: acquisitionSourceSchema,
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type User = z.infer<typeof userSchema>

export const userListSchema = z.array(userSchema)
