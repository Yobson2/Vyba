import { type CellContext } from '@tanstack/react-table'
import { toast } from 'sonner'
import { DataTableRowActions, type RowAction } from '@/components/ui/data-table'
import {
  useHidePhotoMutation,
  usePromotePhotoMutation,
} from '../api/curation-api'
import { useCuration } from '../context/curation-context'
import { CurationQueueItem } from '../data/schema'

export function CurationRowActionsCell({
  row,
}: CellContext<CurationQueueItem, unknown>) {
  const item = row.original
  const { setOpen, setCurrentRow } = useCuration()
  const promotePhoto = usePromotePhotoMutation()
  const hidePhoto = useHidePhotoMutation()

  const actions: RowAction<CurationQueueItem>[] = []

  if (item.status === 'active') {
    if (!item.feedPromoted) {
      actions.push({
        label: 'Promote to feed',
        onSelect: () => {
          promotePhoto.mutate(item.id, {
            onSuccess: () => toast.success('Promoted to the main feed'),
            onError: () => toast.error('Failed to promote'),
          })
        },
      })
    }
    actions.push({
      label: 'Hide',
      onSelect: () => {
        hidePhoto.mutate(item.id, {
          onSuccess: () => toast.success('Hidden'),
          onError: () => toast.error('Failed to hide'),
        })
      },
    })
  }

  if (item.status !== 'deleted') {
    actions.push({
      label: 'Delete',
      destructive: true,
      separatorBefore: actions.length > 0,
      onSelect: () => {
        setCurrentRow(item)
        setOpen('delete')
      },
    })
  }

  return <DataTableRowActions row={row} actions={actions} />
}
