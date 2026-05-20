import {
  IconGlass,
  IconBeer,
  IconSofa,
  IconToolsKitchen2,
  IconBuilding,
  IconBeach,
  IconCoffee,
} from '@tabler/icons-react'
import { VenueStatus } from './schema'

export const statusTypes = new Map<VenueStatus, string>([
  [
    'active',
    'bg-teal-100/30 text-teal-900 dark:text-teal-200 border-teal-200',
  ],
  [
    'pending',
    'bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200',
  ],
  ['suspended', 'bg-neutral-300/40 border-neutral-300'],
  [
    'rejected',
    'bg-destructive/10 dark:bg-destructive/50 text-destructive dark:text-primary border-destructive/10',
  ],
])

export const venueTypes = [
  {
    label: 'Club',
    value: 'club',
    icon: IconGlass,
  },
  {
    label: 'Bar',
    value: 'bar',
    icon: IconBeer,
  },
  {
    label: 'Lounge',
    value: 'lounge',
    icon: IconSofa,
  },
  {
    label: 'Restaurant',
    value: 'restaurant',
    icon: IconToolsKitchen2,
  },
  {
    label: 'Rooftop',
    value: 'rooftop',
    icon: IconBuilding,
  },
  {
    label: 'Beach Club',
    value: 'beach_club',
    icon: IconBeach,
  },
  {
    label: 'Maquis',
    value: 'maquis',
    icon: IconCoffee,
  },
] as const

export const priceLevels = [
  { label: '\u20A6', value: '1' },
  { label: '\u20A6\u20A6', value: '2' },
  { label: '\u20A6\u20A6\u20A6', value: '3' },
  { label: '\u20A6\u20A6\u20A6\u20A6', value: '4' },
] as const
