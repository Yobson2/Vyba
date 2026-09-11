import { IconGlass, IconBeer, IconSofa, IconCoffee } from '@tabler/icons-react'
import { ValidationStatus, VenueType } from './schema'

export const statusTypes = new Map<ValidationStatus, string>([
  [
    'ONBOARDING',
    'bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200',
  ],
  ['ACTIVE', 'bg-teal-100/30 text-teal-900 dark:text-teal-200 border-teal-200'],
  ['PAUSED', 'bg-neutral-300/40 border-neutral-300'],
])

export const statusOptions: { label: string; value: ValidationStatus }[] = [
  { label: 'Onboarding', value: 'ONBOARDING' },
  { label: 'Active', value: 'ACTIVE' },
  { label: 'Paused', value: 'PAUSED' },
]

export const venueTypes: {
  label: string
  value: VenueType
  icon: typeof IconGlass
}[] = [
  { label: 'Club', value: 'CLUB', icon: IconGlass },
  { label: 'Bar', value: 'BAR', icon: IconBeer },
  { label: 'Lounge', value: 'LOUNGE', icon: IconSofa },
  { label: 'Maquis', value: 'MAQUIS', icon: IconCoffee },
]

export const priceLevels = [
  { label: 'F', value: '1' },
  { label: 'FF', value: '2' },
  { label: 'FFF', value: '3' },
  { label: 'FFFF', value: '4' },
] as const
