import { IconBuilding, IconUser } from '@tabler/icons-react'
import { AcquisitionSource, UserStatus } from './schema'

export const statusTypes = new Map<UserStatus, string>([
  ['active', 'bg-teal-100/30 text-teal-900 dark:text-teal-200 border-teal-200'],
  ['inactive', 'bg-neutral-300/40 border-neutral-300'],
  [
    'suspended',
    'bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200',
  ],
  [
    'banned',
    'bg-destructive/10 dark:bg-destructive/50 text-destructive dark:text-primary border-destructive/10',
  ],
])

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
  { label: 'Web', value: 'web' },
  { label: 'Referral', value: 'referral' },
  { label: 'Organic', value: 'organic' },
  { label: 'Campaign', value: 'campaign' },
]
