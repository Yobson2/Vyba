import { ColumnDef } from '@tanstack/react-table'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { Checkbox } from '@/components/ui/checkbox'
import { statusTypes, zoneTypes } from '../data/data'
import { Booking } from '../data/schema'
import { DataTableColumnHeader } from './data-table-column-header'
import { DataTableRowActions } from './data-table-row-actions'

export const columns: ColumnDef<Booking>[] = [
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
    accessorKey: 'reference',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Reference' />
    ),
    cell: ({ row }) => (
      <div className='font-mono text-sm text-nowrap'>
        {row.getValue('reference')}
      </div>
    ),
    enableHiding: false,
  },
  {
    accessorKey: 'guestName',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Guest' />
    ),
    cell: ({ row }) => (
      <div className='max-w-36 truncate font-medium'>
        {row.getValue('guestName')}
      </div>
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
    accessorKey: 'venueName',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Venue' />
    ),
    cell: ({ row }) => (
      <div className='text-nowrap'>{row.getValue('venueName')}</div>
    ),
  },
  {
    accessorKey: 'date',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Date' />
    ),
    cell: ({ row }) => {
      const date = row.getValue('date') as Date
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
    accessorKey: 'timeSlot',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Time' />
    ),
    cell: ({ row }) => (
      <div className='text-nowrap'>{row.getValue('timeSlot')}</div>
    ),
    enableSorting: false,
  },
  {
    accessorKey: 'guestCount',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Guests' />
    ),
    cell: ({ row }) => (
      <div className='text-center'>{row.getValue('guestCount')}</div>
    ),
  },
  {
    accessorKey: 'zone',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Zone' />
    ),
    cell: ({ row }) => {
      const { zone } = row.original
      const zoneType = zoneTypes.find(({ value }) => value === zone)

      if (!zoneType) return null

      return (
        <div className='flex items-center gap-x-2'>
          {zoneType.icon && (
            <zoneType.icon size={16} className='text-muted-foreground' />
          )}
          <span className='text-sm text-nowrap'>{zoneType.label}</span>
        </div>
      )
    },
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
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
    accessorKey: 'depositAmount',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Deposit' />
    ),
    cell: ({ row }) => {
      const amount = row.getValue('depositAmount') as number
      return (
        <div className='text-nowrap font-medium'>
          {'\u20A6'}{amount.toLocaleString()}
        </div>
      )
    },
  },
  {
    id: 'actions',
    cell: DataTableRowActions,
  },
]
