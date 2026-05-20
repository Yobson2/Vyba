import { ColumnDef } from '@tanstack/react-table'
import { IconDotsVertical } from '@tabler/icons-react'
import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { ROLE_LABELS } from '@/types/admin'
import type { Admin } from '../data/schema'
import { useAdmins } from '../context/admins-context'

const statusColors: Record<string, string> = {
  active: 'bg-secondary/20 text-secondary-foreground',
  invited: 'bg-tertiary/20 text-tertiary',
  deactivated: 'bg-destructive/20 text-destructive',
}

function AdminActions({ admin }: { admin: Admin }) {
  const { setOpen, setCurrentRow } = useAdmins()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant='ghost' size='icon' className='h-8 w-8'>
          <IconDotsVertical size={16} />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align='end'>
        <DropdownMenuItem
          onClick={() => {
            setCurrentRow(admin)
            setOpen('edit')
          }}
        >
          Edit role
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          className='text-destructive'
          onClick={() => {
            setCurrentRow(admin)
            setOpen('delete')
          }}
        >
          {admin.status === 'active' ? 'Deactivate' : 'Remove'}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
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
      <span className='text-sm'>
        {ROLE_LABELS[row.original.role]}
      </span>
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
      if (!date) return <span className='text-muted-foreground text-sm'>Never</span>
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
    cell: ({ row }) => <AdminActions admin={row.original} />,
  },
]
