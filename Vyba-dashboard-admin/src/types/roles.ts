/**
 * User roles — single source of truth for the dashboard.
 *
 * Mirrors the backend role constant (see backend `common/constants/roles.constant.ts`,
 * validation MVP unit 01). The client-side role is a UX hint only; the backend
 * re-validates permissions on every request.
 */

export const USER_ROLES = ['ADMIN', 'VENUE_OWNER', 'CLIENT'] as const

export type UserRole = (typeof USER_ROLES)[number]

export const ROLE_LABELS: Record<UserRole, string> = {
  ADMIN: 'Admin',
  VENUE_OWNER: 'Venue owner',
  CLIENT: 'Client',
}
