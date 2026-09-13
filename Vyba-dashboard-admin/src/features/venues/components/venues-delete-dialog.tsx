'use client'

import { useState } from 'react'
import { IconAlertTriangle } from '@tabler/icons-react'
import { toast } from 'sonner'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { ConfirmDialog } from '@/components/confirm-dialog'
import { useDeactivateVenueMutation } from '../api/venues-api'
import { Venue } from '../data/schema'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  currentRow: Venue
}

export function VenuesDeleteDialog({ open, onOpenChange, currentRow }: Props) {
  const [value, setValue] = useState('')
  const deactivateVenue = useDeactivateVenueMutation()

  const handleDelete = () => {
    if (value.trim() !== currentRow.name) return

    deactivateVenue.mutate(currentRow.id, {
      onSuccess: () => {
        onOpenChange(false)
        toast.success('Venue deactivated', {
          description: `${currentRow.name} has been removed.`,
        })
      },
      onError: () => {
        toast.error('Failed to deactivate venue')
      },
    })
  }

  return (
    <ConfirmDialog
      open={open}
      onOpenChange={onOpenChange}
      handleConfirm={handleDelete}
      disabled={value.trim() !== currentRow.name}
      isLoading={deactivateVenue.isPending}
      title={
        <span className='text-destructive'>
          <IconAlertTriangle
            className='stroke-destructive mr-1 inline-block'
            size={18}
          />{' '}
          Deactivate Venue
        </span>
      }
      desc={
        <div className='space-y-4'>
          <p className='mb-2'>
            Are you sure you want to deactivate{' '}
            <span className='font-bold'>{currentRow.name}</span>?
            <br />
            It will stop appearing anywhere in the app. This can be reversed by
            an admin later if needed.
          </p>

          <Label className='my-2'>
            Venue name:
            <Input
              value={value}
              onChange={(e) => setValue(e.target.value)}
              placeholder='Enter venue name to confirm.'
            />
          </Label>

          <Alert variant='destructive'>
            <AlertTitle>Warning!</AlertTitle>
            <AlertDescription>
              This immediately removes the venue from the feed and search.
            </AlertDescription>
          </Alert>
        </div>
      }
      confirmText='Deactivate'
      destructive
    />
  )
}
