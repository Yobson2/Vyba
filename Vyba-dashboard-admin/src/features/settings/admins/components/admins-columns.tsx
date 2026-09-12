import { ColumnDef } from '@tanstack/react-table'
import { ROLE_LABELS } from '@/types/admin'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import type { Admin } from '../data/schema'
import { AdminRowActions } from './admin-row-actions'

const statusColors: Record<string, string> = {
  active: 'bg-secondary/20 text-secondary-foreground',
  invited: 'bg-tertiary/20 text-tertiary',
  deactivated: 'bg-destructive/20 text-destructive',
}

export const adminsColumns: ColumnDef<Admin>[] = [
  {
    accessorKey: 'name',
    header: 'Name',
    cell: ({ row }) => (
      <div>
        <p className='text-sm font-medium'>{row.getValue('name')}</p>
        <p className='text-muted-foreground text-xs'>{row.original.email}</p>
      </div>
    ),
  },
  {
    accessorKey: 'role',
    header: 'Role',
    cell: ({ row }) => (
      <span className='text-sm'>{ROLE_LABELS[row.original.role]}</span>
    ),
    filterFn: (row, id, value) => value.includes(row.getValue(id)),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.original.status
      return (
        <Badge
          variant='outline'
          className={cn('capitalize', statusColors[status])}
        >
          {status}
        </Badge>
      )
    },
    filterFn: (row, id, value) => value.includes(row.getValue(id)),
  },
  {
    accessorKey: 'lastActive',
    header: 'Last Active',
    cell: ({ row }) => {
      const date = row.original.lastActive
      if (!date)
        return <span className='text-muted-foreground text-sm'>Never</span>
      return (
        <span className='text-sm text-nowrap'>
          {date.toLocaleDateString('en-NG', {
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
