import { ColumnDef } from '@tanstack/react-table'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { Checkbox } from '@/components/ui/checkbox'
import LongText from '@/components/long-text'
import { statusTypes, venueTypes, priceLevels } from '../data/data'
import { Venue } from '../data/schema'
import { DataTableColumnHeader } from './data-table-column-header'
import { DataTableRowActions } from './data-table-row-actions'

export const columns: ColumnDef<Venue>[] = [
  {
    id: 'select',
    header: ({ table }) => (
      <Checkbox
        checked={
          table.getIsAllPageRowsSelected() ||
          (table.getIsSomePageRowsSelected() && 'indeterminate')
        }
        onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
        aria-label='Select all'
        className='translate-y-[2px]'
      />
    ),
    meta: {
      className: cn(
        'sticky md:table-cell left-0 z-10 rounded-tl',
        'bg-background transition-colors duration-200 group-hover/row:bg-muted group-data-[state=selected]/row:bg-muted'
      ),
    },
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value) => row.toggleSelected(!!value)}
        aria-label='Select row'
        className='translate-y-[2px]'
      />
    ),
    enableSorting: false,
    enableHiding: false,
  },
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
        'sticky left-6 md:table-cell'
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
    enableHiding: false,
  },
  {
    accessorKey: 'city',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='City' />
    ),
    cell: ({ row }) => <div>{row.getValue('city')}</div>,
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
    },
    enableSorting: false,
  },
  {
    accessorKey: 'rating',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Rating' />
    ),
    cell: ({ row }) => {
      const rating = row.getValue('rating') as number
      return (
        <div className='flex items-center gap-x-1'>
          <span className='text-amber-500'>&#9733;</span>
          <span className='text-sm'>{rating.toFixed(1)}</span>
        </div>
      )
    },
  },
  {
    accessorKey: 'reviewCount',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Reviews' />
    ),
    cell: ({ row }) => (
      <div className='text-center'>{row.getValue('reviewCount')}</div>
    ),
  },
  {
    accessorKey: 'priceLevel',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Price' />
    ),
    cell: ({ row }) => {
      const level = row.getValue('priceLevel') as number
      const priceLabel =
        priceLevels.find((p) => p.value === String(level))?.label ??
        '\u20A6'
      return <div className='text-sm'>{priceLabel}</div>
    },
    enableSorting: false,
  },
  {
    accessorKey: 'status',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Status' />
    ),
    cell: ({ row }) => {
      const { status } = row.original
      const badgeColor = statusTypes.get(status)
      return (
        <div className='flex space-x-2'>
          <Badge variant='outline' className={cn('capitalize', badgeColor)}>
            {status}
          </Badge>
        </div>
      )
    },
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
    },
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'isPremium',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Premium' />
    ),
    cell: ({ row }) => {
      const isPremium = row.getValue('isPremium') as boolean
      return isPremium ? (
        <Badge
          variant='outline'
          className='bg-amber-100/30 text-amber-900 dark:text-amber-200 border-amber-200'
        >
          Premium
        </Badge>
      ) : (
        <span className='text-muted-foreground'>&mdash;</span>
      )
    },
    enableSorting: false,
  },
  {
    accessorKey: 'ownerName',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Owner' />
    ),
    cell: ({ row }) => (
      <LongText className='max-w-36'>{row.getValue('ownerName')}</LongText>
    ),
  },
  {
    accessorKey: 'createdAt',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Created' />
    ),
    cell: ({ row }) => {
      const date = row.getValue('createdAt') as Date
      return (
        <div className='text-nowrap'>
          {date.toLocaleDateString('en-NG', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          })}
        </div>
      )
    },
  },
  {
    id: 'actions',
    cell: DataTableRowActions,
  },
]
