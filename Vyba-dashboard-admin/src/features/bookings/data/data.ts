import { IconArmchair, IconTrees, IconDiamond } from '@tabler/icons-react'
import { BookingStatus } from './schema'

export const statusTypes = new Map<BookingStatus, string>([
  [
    'pending',
    'bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200',
  ],
  [
    'confirmed',
    'bg-teal-100/30 text-teal-900 dark:text-teal-200 border-teal-200',
  ],
  [
    'cancelled',
    'bg-destructive/10 dark:bg-destructive/50 text-destructive dark:text-primary border-destructive/10',
  ],
  ['completed', 'bg-sky-100/30 text-sky-900 dark:text-sky-200 border-sky-200'],
])

export const zoneTypes = [
  {
    label: 'Indoor Lounge',
    value: 'indoor_lounge',
    icon: IconArmchair,
  },
  {
    label: 'Outdoor Terrace',
    value: 'outdoor_terrace',
    icon: IconTrees,
  },
  {
    label: 'VIP Booth',
    value: 'vip_booth',
    icon: IconDiamond,
  },
] as const
