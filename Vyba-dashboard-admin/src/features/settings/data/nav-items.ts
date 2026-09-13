import {
  IconLock,
  IconPalette,
  IconUser,
  IconUserShield,
} from '@tabler/icons-react'

export interface SettingsNavItem {
  title: string
  href: string
  icon: typeof IconUser
}

// Every dashboard account is ADMIN during the validation phase (the backend
// issues no other dashboard role) — so there is no per-role nav filtering
// here. If real role granularity is built later (backend roles beyond
// ADMIN), re-add a `requiredRoles` field and filter in `Settings`
// (`features/settings/index.tsx`), not just declare it unused.
export const SETTINGS_NAV_ITEMS: SettingsNavItem[] = [
  {
    title: 'Security',
    href: '/settings/security',
    icon: IconLock,
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
  },
]
