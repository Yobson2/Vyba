'use client'

import { IconAlertTriangle } from '@tabler/icons-react'
import { toast } from 'sonner'
import { ConfirmDialog } from '@/components/confirm-dialog'
import { useDeletePhotoMutation } from '../api/curation-api'
import { CurationQueueItem } from '../data/schema'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  currentRow: CurationQueueItem
}

export function CurationDeleteDialog({
  open,
  onOpenChange,
  currentRow,
}: Props) {
  const deletePhoto = useDeletePhotoMutation()

  const handleDelete = () => {
    deletePhoto.mutate(currentRow.id, {
      onSuccess: () => {
        onOpenChange(false)
        toast.success('Photo deleted')
      },
      onError: () => toast.error('Failed to delete photo'),
    })
  }

  return (
    <ConfirmDialog
      open={open}
      onOpenChange={onOpenChange}
      handleConfirm={handleDelete}
      isLoading={deletePhoto.isPending}
      title={
        <span className='text-destructive'>
          <IconAlertTriangle
            className='stroke-destructive mr-1 inline-block'
            size={18}
          />{' '}
          Delete photo
        </span>
      }
      desc={
        <p>
          Permanently delete this photo?
          {currentRow.feedPromoted &&
            ' It is currently promoted to the main feed — deleting it removes it from there too.'}{' '}
          This can&apos;t be undone.
        </p>
      }
      confirmText='Delete'
      destructive
    />
  )
}
