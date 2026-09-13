import { z } from 'zod'

// The backend returns every role (see `Vyba-backend` UsersController.findAll,
// unfiltered) — ADMIN rows are parsed here but filtered out by the query hook
// before display; team members live in settings/admins, not this screen.
const userRoleSchema = z.union([
  z.literal('CLIENT'),
  z.literal('VENUE_OWNER'),
  z.literal('ADMIN'),
])
export type UserRole = z.infer<typeof userRoleSchema>

// Matches spec 07's attribution `src` values (see `capture-landing.dto.ts`).
const acquisitionSourceSchema = z.union([
  z.literal('qr'),
  z.literal('promoter'),
  z.literal('social'),
  z.literal('organic'),
])
export type AcquisitionSource = z.infer<typeof acquisitionSourceSchema>

const userSchema = z.object({
  id: z.string(),
  phone: z.string(),
  firstName: z.string().nullable(),
  lastName: z.string().nullable(),
  role: userRoleSchema,
  isActive: z.boolean(),
  acquisitionSource: acquisitionSourceSchema.nullable(),
  acquisitionZone: z.string().nullable(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type User = z.infer<typeof userSchema>

export const userListSchema = z.array(userSchema)
