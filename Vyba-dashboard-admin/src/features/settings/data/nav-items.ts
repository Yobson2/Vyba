import { IconPalette, IconUser, IconUserShield } from '@tabler/icons-react'
import type { AdminRole } from '@/types/admin'

export interface SettingsNavItem {
  title: string
  href: string
  icon: typeof IconUser
  requiredRoles?: AdminRole[]
}

export const SETTINGS_NAV_ITEMS: SettingsNavItem[] = [
  {
    title: 'Appearance',
    href: '/settings/appearance',
    icon: IconPalette,
  },
  {
    title: 'Admin Users',
    href: '/settings/admins',
    icon: IconUserShield,
    requiredRoles: ['ADMIN'],
  },
]
