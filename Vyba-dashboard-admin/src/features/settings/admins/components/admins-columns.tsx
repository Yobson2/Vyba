import { ColumnDef } from '@tanstack/react-table'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import type { Admin } from '../data/schema'
import { AdminRowActions } from './admin-row-actions'

export const adminsColumns: ColumnDef<Admin>[] = [
  {
    id: 'name',
    accessorFn: (row) =>
      [row.firstName, row.lastName].filter(Boolean).join(' ') || row.email,
    header: 'Name',
    cell: ({ row }) => {
      const name = [row.original.firstName, row.original.lastName]
        .filter(Boolean)
        .join(' ')
      return (
        <div>
          <p className='text-sm font-medium'>{name || '—'}</p>
          <p className='text-muted-foreground text-xs'>{row.original.email}</p>
        </div>
      )
    },
  },
  {
    accessorKey: 'isActive',
    header: 'Status',
    cell: ({ row }) => {
      const isActive = row.original.isActive
      return (
        <Badge
          variant='outline'
          className={cn(
            'capitalize',
            isActive
              ? 'bg-secondary/20 text-secondary-foreground'
              : 'bg-destructive/20 text-destructive'
          )}
        >
          {isActive ? 'Active' : 'Deactivated'}
        </Badge>
      )
    },
    filterFn: (row, id, value) => value.includes(String(row.getValue(id))),
  },
  {
    accessorKey: 'createdAt',
    header: 'Added',
    cell: ({ row }) => {
      const date = row.original.createdAt
      return (
        <span className='text-sm text-nowrap'>
          {date.toLocaleDateString('en-GB', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          })}
        </span>
      )
    },
  },
  {
    id: 'actions',
    cell: ({ row }) => <AdminRowActions admin={row.original} />,
  },
]
