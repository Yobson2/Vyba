import { ColumnDef } from '@tanstack/react-table'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { DataTableColumnHeader } from '@/components/ui/data-table'
import { acquisitionSourceTypes, roleTypes } from '../data/data'
import { User } from '../data/schema'
import { UserRowActions } from './user-row-actions'

export const columns: ColumnDef<User>[] = [
  {
    id: 'name',
    accessorFn: (row) =>
      [row.firstName, row.lastName].filter(Boolean).join(' '),
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Name' />
    ),
    cell: ({ getValue }) => (
      <div className='max-w-36 truncate'>{(getValue() as string) || '—'}</div>
    ),
    meta: {
      className: cn(
        'drop-shadow-[0_1px_2px_rgb(0_0_0_/_0.1)] dark:drop-shadow-[0_1px_2px_rgb(255_255_255_/_0.1)] lg:drop-shadow-none',
        'bg-background transition-colors duration-200 group-hover/row:bg-muted group-data-[state=selected]/row:bg-muted',
        'sticky left-0 md:table-cell'
      ),
    },
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'phone',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Phone' />
    ),
    cell: ({ row }) => (
      <div className='text-nowrap'>{row.getValue('phone')}</div>
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: 'role',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Role' />
    ),
    cell: ({ row }) => {
      const { role } = row.original
      const roleType = roleTypes.find(({ value }) => value === role)

      if (!roleType) return null

      return (
        <div className='flex items-center gap-x-2'>
          {roleType.icon && (
            <roleType.icon size={16} className='text-muted-foreground' />
          )}
          <span className='text-sm'>{roleType.label}</span>
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
    accessorKey: 'isActive',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Status' />
    ),
    cell: ({ row }) => {
      const isActive = row.getValue('isActive') as boolean
      return (
        <div className='flex space-x-2'>
          <Badge
            variant='outline'
            className={cn(
              'capitalize',
              isActive
                ? 'border-teal-200 bg-teal-100/30 text-teal-900 dark:text-teal-200'
                : 'border-neutral-300 bg-neutral-300/40'
            )}
          >
            {isActive ? 'Active' : 'Inactive'}
          </Badge>
        </div>
      )
    },
    filterFn: (row, id, value) => {
      return value.includes(String(row.getValue(id)))
    },
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'acquisitionSource',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Acquisition' />
    ),
    cell: ({ row }) => {
      const source = acquisitionSourceTypes.find(
        ({ value }) => value === row.original.acquisitionSource
      )
      return <div className='text-nowrap'>{source?.label ?? '—'}</div>
    },
    filterFn: (row, id, value) => {
      return value.includes(row.getValue(id))
    },
    enableSorting: false,
  },
  {
    accessorKey: 'createdAt',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Joined' />
    ),
    cell: ({ row }) => {
      const date = row.getValue('createdAt') as Date
      return (
        <div className='text-nowrap'>
          {date.toLocaleDateString('en-GB', {
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
    cell: ({ row }) => <UserRowActions user={row.original} />,
  },
]
