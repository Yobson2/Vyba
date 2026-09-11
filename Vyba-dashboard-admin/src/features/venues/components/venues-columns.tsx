import { ColumnDef } from '@tanstack/react-table'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { DataTableColumnHeader } from '@/components/ui/data-table'
import LongText from '@/components/long-text'
import { priceLevels, statusTypes, venueTypes } from '../data/data'
import { Venue } from '../data/schema'
import { VenuesRowActionsCell } from './venues-row-actions-cell'

export const columns: ColumnDef<Venue>[] = [
  {
    accessorKey: 'name',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Name' />
    ),
    cell: ({ row }) => (
      <LongText className='max-w-36'>{row.getValue('name')}</LongText>
    ),
    meta: {
      className: cn(
        'drop-shadow-[0_1px_2px_rgb(0_0_0_/_0.1)] dark:drop-shadow-[0_1px_2px_rgb(255_255_255_/_0.1)] lg:drop-shadow-none',
        'bg-background transition-colors duration-200 group-hover/row:bg-muted group-data-[state=selected]/row:bg-muted',
        'sticky left-0 md:table-cell'
      ),
    },
    enableHiding: false,
  },
  {
    accessorKey: 'venueType',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Type' />
    ),
    cell: ({ row }) => {
      const { venueType } = row.original
      const type = venueTypes.find(({ value }) => value === venueType)

      if (!type) return null

      return (
        <div className='flex items-center gap-x-2'>
          {type.icon && (
            <type.icon size={16} className='text-muted-foreground' />
          )}
          <span className='text-sm'>{type.label}</span>
        </div>
      )
    },
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
    },
    enableSorting: false,
  },
  {
    accessorKey: 'address',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Address' />
    ),
    cell: ({ row }) => (
      <LongText className='max-w-48'>{row.getValue('address') ?? '—'}</LongText>
    ),
    enableSorting: false,
  },
  {
    accessorKey: 'priceLevel',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Price' />
    ),
    cell: ({ row }) => {
      const level = row.getValue('priceLevel') as number
      const priceLabel =
        priceLevels.find((p) => p.value === String(level))?.label ?? 'F'
      return <div className='text-sm'>{priceLabel}</div>
    },
    enableSorting: false,
  },
  {
    accessorKey: 'validationStatus',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Status' />
    ),
    cell: ({ row }) => {
      const { validationStatus } = row.original
      const badgeColor = statusTypes.get(validationStatus)
      return (
        <Badge variant='outline' className={cn('capitalize', badgeColor)}>
          {validationStatus.toLowerCase()}
        </Badge>
      )
    },
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
    },
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'inLaunchArea',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Zone 4' />
    ),
    cell: ({ row }) => {
      const inLaunchArea = row.getValue('inLaunchArea') as boolean
      return inLaunchArea ? (
        <Badge
          variant='outline'
          className='border-emerald-200 bg-emerald-100/30 text-emerald-900 dark:text-emerald-200'
        >
          Zone 4
        </Badge>
      ) : (
        <Badge
          variant='outline'
          className='border-neutral-300 bg-neutral-300/40'
        >
          Hors zone
        </Badge>
      )
    },
    enableSorting: false,
  },
  {
    accessorKey: 'owner',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Owner' />
    ),
    cell: ({ row }) => {
      const owner = row.original.owner
      if (!owner) {
        return <span className='text-muted-foreground'>Not bound</span>
      }
      const name = [owner.firstName, owner.lastName].filter(Boolean).join(' ')
      return (
        <div className='text-sm'>
          {name ? <div>{name}</div> : null}
          <div
            className={cn(
              'text-nowrap',
              name && 'text-muted-foreground text-xs'
            )}
          >
            {owner.phone}
          </div>
        </div>
      )
    },
    enableSorting: false,
  },
  {
    id: 'actions',
    cell: VenuesRowActionsCell,
  },
]
