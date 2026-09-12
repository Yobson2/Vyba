import { ColumnDef } from '@tanstack/react-table'
import { Badge, badgeVariants } from '@/components/ui/badge'
import { DataTableColumnHeader } from '@/components/ui/data-table'
import LongText from '@/components/long-text'
import { displayStatus, EditorialItem } from '../data/schema'
import { EditorialRowActionsCell } from './editorial-row-actions-cell'

type BadgeVariant = NonNullable<Parameters<typeof badgeVariants>[0]>['variant']

const STATUS_LABEL: Record<string, string> = {
  draft: 'Draft',
  scheduled: 'Scheduled',
  published: 'Published',
  expired: 'Expired',
  hidden: 'Hidden',
}

const STATUS_VARIANT: Record<string, BadgeVariant> = {
  draft: 'secondary',
  scheduled: 'warning',
  published: 'success',
  expired: 'secondary',
  hidden: 'destructive',
}

export const columns: ColumnDef<EditorialItem>[] = [
  {
    accessorKey: 'title',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Title' />
    ),
    accessorFn: (row) => row.payload.title,
    cell: ({ row }) => (
      <LongText className='max-w-64 font-medium'>
        {row.original.payload.title}
      </LongText>
    ),
    enableHiding: false,
  },
  {
    id: 'status',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Status' />
    ),
    cell: ({ row }) => {
      const status = displayStatus(row.original)
      return (
        <Badge variant={STATUS_VARIANT[status]}>{STATUS_LABEL[status]}</Badge>
      )
    },
    enableSorting: false,
  },
  {
    accessorKey: 'publishedAt',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Published' />
    ),
    cell: ({ row }) => (
      <span className='text-muted-foreground text-sm'>
        {row.original.publishedAt.toLocaleString()}
      </span>
    ),
  },
  {
    accessorKey: 'expiresAt',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Expires' />
    ),
    cell: ({ row }) => (
      <span className='text-muted-foreground text-sm'>
        {row.original.expiresAt ? row.original.expiresAt.toLocaleString() : '—'}
      </span>
    ),
  },
  {
    id: 'actions',
    cell: EditorialRowActionsCell,
  },
]
