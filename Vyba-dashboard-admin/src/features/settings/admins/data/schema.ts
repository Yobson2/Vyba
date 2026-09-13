import { z } from 'zod'

// Every row here is a real ADMIN account (dashboard access) — there is no
// separate role/status enum: "status" is just `isActive`.
const adminSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  firstName: z.string().nullable(),
  lastName: z.string().nullable(),
  isActive: z.boolean(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type Admin = z.infer<typeof adminSchema>

export const adminListSchema = z.array(adminSchema)
