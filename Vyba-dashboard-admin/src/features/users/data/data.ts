import { IconBuilding, IconUser } from '@tabler/icons-react'
import { AcquisitionSource } from './schema'

// ADMIN is intentionally excluded — those rows never reach this screen
// (filtered out in `useUsersQuery`); team members live in settings/admins.
export const roleTypes = [
  {
    label: 'Client',
    value: 'CLIENT',
    icon: IconUser,
  },
  {
    label: 'Venue Owner',
    value: 'VENUE_OWNER',
    icon: IconBuilding,
  },
] as const

export const acquisitionSourceTypes: {
  label: string
  value: AcquisitionSource
}[] = [
  { label: 'Venue QR', value: 'qr' },
  { label: 'Promoter', value: 'promoter' },
  { label: 'Social', value: 'social' },
  { label: 'Organic', value: 'organic' },
]
