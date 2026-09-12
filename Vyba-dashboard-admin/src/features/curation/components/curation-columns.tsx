import { ColumnDef } from '@tanstack/react-table'
import { Badge, badgeVariants } from '@/components/ui/badge'
import { DataTableColumnHeader } from '@/components/ui/data-table'
import { CurationQueueItem } from '../data/schema'
import { CurationRowActionsCell } from './curation-row-actions-cell'
import { CurationVenueCell } from './curation-venue-cell'

type BadgeVariant = NonNullable<Parameters<typeof badgeVariants>[0]>['variant']

const STATUS_LABEL: Record<string, string> = {
  active: 'Active',
  hidden: 'Hidden',
  deleted: 'Deleted',
}

const STATUS_VARIANT: Record<string, BadgeVariant> = {
  active: 'success',
  hidden: 'destructive',
  deleted: 'secondary',
}

export const columns: ColumnDef<CurationQueueItem>[] = [
  {
    id: 'thumbnail',
    header: 'Photo',
    cell: ({ row }) => (
      <img
        src={row.original.thumbnailUrl}
        alt=''
        className='h-12 w-12 rounded-md object-cover'
      />
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    id: 'venue',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Venue' />
    ),
    cell: ({ row }) => <CurationVenueCell venueId={row.original.venueId} />,
    enableSorting: false,
  },
  {
    accessorKey: 'venueNightDate',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Night' />
    ),
    cell: ({ row }) => (
      <span className='text-muted-foreground text-sm'>
        {row.original.venueNightDate ?? '—'}
      </span>
    ),
  },
  {
    accessorKey: 'uploadedByUserId',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Uploader' />
    ),
    cell: ({ row }) => (
      <span className='text-muted-foreground font-mono text-xs'>
        {row.original.uploadedByUserId.slice(0, 8)}
      </span>
    ),
    enableSorting: false,
  },
  {
    id: 'status',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Status' />
    ),
    cell: ({ row }) => {
      const { status, feedPromoted } = row.original
      return (
        <div className='flex items-center gap-1.5'>
          <Badge variant={STATUS_VARIANT[status]}>{STATUS_LABEL[status]}</Badge>
          {feedPromoted && <Badge variant='info'>In feed</Badge>}
        </div>
      )
    },
    enableSorting: false,
  },
  {
    accessorKey: 'createdAt',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title='Uploaded' />
    ),
    cell: ({ row }) => (
      <span className='text-muted-foreground text-sm'>
        {row.original.createdAt.toLocaleString()}
      </span>
    ),
  },
  {
    id: 'actions',
    cell: CurationRowActionsCell,
  },
]
