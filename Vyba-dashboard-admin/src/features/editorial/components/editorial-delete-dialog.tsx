'use client'

import { IconAlertTriangle } from '@tabler/icons-react'
import { toast } from 'sonner'
import { ConfirmDialog } from '@/components/confirm-dialog'
import { useDeleteFeedItemMutation } from '../api/editorial-api'
import { EditorialItem } from '../data/schema'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  currentRow: EditorialItem
}

export function EditorialDeleteDialog({
  open,
  onOpenChange,
  currentRow,
}: Props) {
  const deleteItem = useDeleteFeedItemMutation()

  const handleDelete = () => {
    deleteItem.mutate(currentRow.id, {
      onSuccess: () => {
        onOpenChange(false)
        toast.success('Editorial item deleted')
      },
      onError: () => toast.error('Failed to delete item'),
    })
  }

  return (
    <ConfirmDialog
      open={open}
      onOpenChange={onOpenChange}
      handleConfirm={handleDelete}
      isLoading={deleteItem.isPending}
      title={
        <span className='text-destructive'>
          <IconAlertTriangle
            className='stroke-destructive mr-1 inline-block'
            size={18}
          />{' '}
          Delete editorial item
        </span>
      }
      desc={
        <p>
          Permanently delete{' '}
          <span className='font-bold'>{currentRow.payload.title}</span>? This
          can&apos;t be undone — use &quot;Unpublish&quot; instead if you might
          want it back.
        </p>
      }
      confirmText='Delete'
      destructive
    />
  )
}
