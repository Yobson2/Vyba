import {
  IconBuilding,
  IconCameraCheck,
  IconChartBar,
  IconLayoutDashboard,
  IconPencil,
  IconSettings,
  IconSpeakerphone,
  IconUsers,
} from '@tabler/icons-react'
import { Logo } from '@/components/logo'
import { SETTINGS_NAV_ITEMS } from '@/features/settings/data/nav-items'
import { type SidebarData } from '../types'

/**
 * The dashboard is the Vyba team's operational cockpit for the validation phase.
 * Navigation is organised around the operational surfaces (see
 * `Vyba-dashboard-admin/CONTEXT.md`). Surfaces that aren't built yet point at a
 * "coming soon" placeholder page.
 */
export const sidebarData: SidebarData = {
  user: {
    name: 'Admin',
    email: 'admin@vyba.app',
    avatar: '/avatars/01.png',
  },
  teams: [
    {
      name: 'Vyba Admin',
      logo: Logo,
      plan: 'Abidjan Pulse',
    },
  ],
  navGroups: [
    {
      title: 'Provisioning',
      items: [
        {
          title: 'Venues & owners',
          url: '/venues',
          icon: IconBuilding,
        },
        {
          title: 'Users',
          url: '/users',
          icon: IconUsers,
        },
      ],
    },
    {
      title: 'Content & curation',
      items: [
        {
          title: 'Editorial composer',
          url: '/editorial',
          icon: IconPencil,
        },
        {
          title: 'Assist mode',
          url: '/promotions',
          icon: IconSpeakerphone,
        },
        {
          title: 'Photo curation',
          url: '/curation',
          icon: IconCameraCheck,
        },
      ],
    },
    {
      title: 'Monitoring & metrics',
      items: [
        {
          title: 'VenueNight monitor',
          url: '/dashboard',
          icon: IconLayoutDashboard,
        },
        {
          title: 'Validation metrics',
          url: '/analytics',
          icon: IconChartBar,
        },
      ],
    },
    {
      title: 'Settings',
      items: [
        {
          title: 'Settings',
          icon: IconSettings,
          items: SETTINGS_NAV_ITEMS.map((item) => ({
            title: item.title,
            url: item.href as '/',
            icon: item.icon,
          })),
        },
      ],
    },
  ],
}
