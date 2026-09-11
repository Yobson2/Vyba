'use client'

import { toast } from 'sonner'
import { ConfirmDialog } from '@/components/confirm-dialog'
import { useUnbindOwnerMutation } from '../api/venues-api'
import { Venue } from '../data/schema'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  currentRow: Venue
}

export function VenuesUnbindOwnerDialog({
  open,
  onOpenChange,
  currentRow,
}: Props) {
  const unbindOwner = useUnbindOwnerMutation()

  const handleUnbind = () => {
    unbindOwner.mutate(currentRow.id, {
      onSuccess: () => {
        onOpenChange(false)
        toast.success('Owner unbound', {
          description: `${currentRow.name} no longer has a bound owner account.`,
        })
      },
      onError: () => {
        toast.error('Failed to unbind owner')
      },
    })
  }

  return (
    <ConfirmDialog
      open={open}
      onOpenChange={onOpenChange}
      handleConfirm={handleUnbind}
      isLoading={unbindOwner.isPending}
      title='Unbind Owner'
      desc={
        <p>
          Remove{' '}
          <span className='font-bold'>
            {currentRow.owner?.firstName ?? currentRow.owner?.phone}
          </span>{' '}
          as the owner of <span className='font-bold'>{currentRow.name}</span>?
          They will lose access to the owner shell for this venue until
          re-bound.
        </p>
      }
      confirmText='Unbind'
      destructive
    />
  )
}
