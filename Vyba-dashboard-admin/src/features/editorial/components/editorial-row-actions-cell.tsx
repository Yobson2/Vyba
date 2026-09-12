import { type CellContext } from '@tanstack/react-table'
import { toast } from 'sonner'
import { DataTableRowActions, type RowAction } from '@/components/ui/data-table'
import {
  useHideFeedItemMutation,
  usePublishFeedItemMutation,
  useUnhideFeedItemMutation,
} from '../api/editorial-api'
import { useEditorial } from '../context/editorial-context'
import { displayStatus, EditorialItem } from '../data/schema'

export function EditorialRowActionsCell({
  row,
}: CellContext<EditorialItem, unknown>) {
  const item = row.original
  const status = displayStatus(item)
  const { setOpen, setCurrentRow } = useEditorial()
  const publishItem = usePublishFeedItemMutation()
  const hideItem = useHideFeedItemMutation()
  const unhideItem = useUnhideFeedItemMutation()

  const actions: RowAction<EditorialItem>[] = [
    {
      label: 'Edit',
      onSelect: () => {
        setCurrentRow(item)
        setOpen('edit')
      },
    },
  ]

  if (status === 'draft') {
    actions.push({
      label: 'Publish',
      onSelect: () => {
        publishItem.mutate(item.id, {
          onSuccess: () => toast.success('Published'),
          onError: () => toast.error('Failed to publish'),
        })
      },
    })
  }

  if (status === 'hidden') {
    actions.push({
      label: 'Republish',
      onSelect: () => {
        unhideItem.mutate(item.id, {
          onSuccess: () => toast.success('Republished'),
          onError: () => toast.error('Failed to republish'),
        })
      },
    })
  } else if (status === 'published' || status === 'scheduled') {
    actions.push({
      label: 'Unpublish',
      onSelect: () => {
        hideItem.mutate(item.id, {
          onSuccess: () => toast.success('Unpublished'),
          onError: () => toast.error('Failed to unpublish'),
        })
      },
    })
  }

  actions.push({
    label: 'Delete',
    destructive: true,
    separatorBefore: true,
    onSelect: () => {
      setCurrentRow(item)
      setOpen('delete')
    },
  })

  return <DataTableRowActions row={row} actions={actions} />
}
