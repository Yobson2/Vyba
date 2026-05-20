import { z } from 'zod'
import type { AdminRole } from '@/types/admin'

const adminStatusSchema = z.union([
  z.literal('active'),
  z.literal('invited'),
  z.literal('deactivated'),
])
export type AdminStatus = z.infer<typeof adminStatusSchema>

const adminRoleSchema: z.ZodType<AdminRole> = z.union([
  z.literal('super_admin'),
  z.literal('admin'),
  z.literal('manager'),
  z.literal('support'),
  z.literal('viewer'),
])

const adminSchema = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string().email(),
  role: adminRoleSchema,
  status: adminStatusSchema,
  lastActive: z.coerce.date().nullable(),
  createdAt: z.coerce.date(),
})

export type Admin = z.infer<typeof adminSchema>
export const adminListSchema = z.array(adminSchema)
