export type AdminRole =
  | 'super_admin'
  | 'admin'
  | 'manager'
  | 'support'
  | 'viewer'

export const ADMIN_ROLES: readonly AdminRole[] = [
  'super_admin',
  'admin',
  'manager',
  'support',
  'viewer',
] as const

export const ROLE_LABELS: Record<AdminRole, string> = {
  super_admin: 'Super Admin',
  admin: 'Admin',
  manager: 'Manager',
  support: 'Support',
  viewer: 'Viewer',
}
