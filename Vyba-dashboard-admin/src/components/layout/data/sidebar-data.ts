import {
  IconBell,
  IconBuilding,
  IconCalendarEvent,
  IconChartBar,
  IconClipboardCheck,
  IconHistory,
  IconLayoutDashboard,
  IconMessageCircle,
  IconSettings,
  IconSpeakerphone,
  IconUsers,
} from '@tabler/icons-react'
import { Logo } from '@/components/logo'
import { type SidebarData } from '../types'
import { SETTINGS_NAV_ITEMS } from '@/features/settings/data/nav-items'

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
      plan: 'Lagos Pulse',
    },
  ],
  navGroups: [
    {
      title: 'Overview',
      items: [
        {
          title: 'Dashboard',
          url: '/dashboard',
          icon: IconLayoutDashboard,
        },
      ],
    },
    {
      title: 'Management',
      items: [
        {
          title: 'Users',
          url: '/users',
          icon: IconUsers,
        },
        {
          title: 'Venues',
          icon: IconBuilding,
          items: [
            {
              title: 'All Venues',
              url: '/venues',
              icon: IconBuilding,
            },
            {
              title: 'Applications',
              url: '/venues/applications',
              icon: IconClipboardCheck,
            },
          ],
        },
        {
          title: 'Bookings',
          url: '/bookings',
          icon: IconCalendarEvent,
        },
        {
          title: 'Reviews',
          url: '/reviews',
          icon: IconMessageCircle,
        },
        {
          title: 'Promotions',
          url: '/promotions',
          icon: IconSpeakerphone,
        },
        {
          title: 'Notifications',
          url: '/notifications',
          icon: IconBell,
        },
      ],
    },
    {
      title: 'Insights',
      items: [
        {
          title: 'Analytics',
          url: '/analytics',
          icon: IconChartBar,
        },
        {
          title: 'Audit Log',
          url: '/audit-log',
          icon: IconHistory,
        },
      ],
    },
    {
      title: 'Configuration',
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
