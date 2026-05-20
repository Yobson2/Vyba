import {
  IconFlame,
  IconCalendarEvent,
  IconDiscount,
} from '@tabler/icons-react'
import { PromoStatus } from './schema'

export const statusTypes = new Map<PromoStatus, string>([
  [
    'active',
    'bg-teal-100/30 text-teal-900 dark:text-teal-200 border-teal-200',
  ],
  [
    'scheduled',
    'bg-sky-100/30 text-sky-900 dark:text-sky-200 border-sky-200',
  ],
  ['expired', 'bg-neutral-300/40 border-neutral-300'],
  [
    'pending',
    'bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200',
  ],
  [
    'rejected',
    'bg-destructive/10 dark:bg-destructive/50 text-destructive dark:text-primary border-destructive/10',
  ],
])

export const promoTypes = [
  {
    label: 'Happy Hour',
    value: 'happy_hour',
    icon: IconFlame,
  },
  {
    label: 'Event',
    value: 'event',
    icon: IconCalendarEvent,
  },
  {
    label: 'Discount',
    value: 'discount',
    icon: IconDiscount,
  },
] as const
