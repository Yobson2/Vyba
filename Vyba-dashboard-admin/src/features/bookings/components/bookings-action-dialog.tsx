'use client'

import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Textarea } from '@/components/ui/textarea'
import { SelectDropdown } from '@/components/select-dropdown'
import { Booking } from '../data/schema'

const formSchema = z.object({
  status: z.string().min(1, { message: 'Status is required.' }),
  reason: z.string().optional(),
})
type BookingForm = z.infer<typeof formSchema>

interface Props {
  currentRow: Booking
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function BookingsActionDialog({
  currentRow,
  open,
  onOpenChange,
}: Props) {
  const form = useForm<BookingForm>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      status: currentRow.status,
      reason: '',
    },
  })

  const onSubmit = (values: BookingForm) => {
    // TODO: Replace with real API call
    form.reset()
    toast.success('Booking updated', {
      description: `${currentRow.reference} status changed to ${values.status}.`,
    })
    onOpenChange(false)
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(state) => {
        form.reset()
        onOpenChange(state)
      }}
    >
      <DialogContent className='sm:max-w-lg'>
        <DialogHeader className='text-left'>
          <DialogTitle>Edit Booking Status</DialogTitle>
          <DialogDescription>
            Update status for booking{' '}
            <span className='font-mono font-semibold'>
              {currentRow.reference}
            </span>{' '}
            — {currentRow.guestName} at {currentRow.venueName}.
          </DialogDescription>
        </DialogHeader>
        <div className='w-full py-1'>
          <Form {...form}>
            <form
              id='booking-form'
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-4 p-0.5'
            >
              <FormField
                control={form.control}
                name='status'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Status
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select status'
                      className='col-span-4'
                      items={[
                        { label: 'Pending', value: 'pending' },
                        { label: 'Confirmed', value: 'confirmed' },
                        { label: 'Cancelled', value: 'cancelled' },
                        { label: 'Completed', value: 'completed' },
                      ]}
                    />
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='reason'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Reason
                    </FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder='Reason for status change (optional)'
                        className='col-span-4'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
            </form>
          </Form>
        </div>
        <DialogFooter>
          <Button type='submit' form='booking-form'>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
