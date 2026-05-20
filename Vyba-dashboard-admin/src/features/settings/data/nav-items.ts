import {
  IconBell,
  IconPalette,
  IconSettings2,
  IconShieldLock,
  IconUser,
  IconUserShield,
} from '@tabler/icons-react'
import type { AdminRole } from '@/types/admin'

export interface SettingsNavItem {
  title: string
  href: string
  icon: typeof IconUser
  requiredRoles?: AdminRole[]
}

export const SETTINGS_NAV_ITEMS: SettingsNavItem[] = [
  {
    title: 'Profile',
    href: '/settings',
    icon: IconUser,
  },
  {
    title: 'Security',
    href: '/settings/security',
    icon: IconShieldLock,
  },
  {
    title: 'Notifications',
    href: '/settings/notifications',
    icon: IconBell,
  },
  {
    title: 'Appearance',
    href: '/settings/appearance',
    icon: IconPalette,
  },
  {
    title: 'Admin Users',
    href: '/settings/admins',
    icon: IconUserShield,
    requiredRoles: ['super_admin', 'admin'],
  },
  {
    title: 'Platform',
    href: '/settings/platform',
    icon: IconSettings2,
    requiredRoles: ['super_admin', 'admin'],
  },
]
