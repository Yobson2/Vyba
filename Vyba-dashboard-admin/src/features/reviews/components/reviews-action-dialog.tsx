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
import { Review } from '../data/schema'

const formSchema = z.object({
  action: z.string().min(1, { message: 'Action is required.' }),
  reason: z.string().optional(),
})
type ReviewForm = z.infer<typeof formSchema>

interface Props {
  currentRow: Review
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function ReviewsActionDialog({
  currentRow,
  open,
  onOpenChange,
}: Props) {
  const form = useForm<ReviewForm>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      action: '',
      reason: '',
    },
  })

  const onSubmit = (values: ReviewForm) => {
    // TODO: Replace with real API call
    form.reset()
    toast.success('Review moderated', {
      description: `Review by ${currentRow.userName} — action: ${values.action}.`,
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
          <DialogTitle>Moderate Review</DialogTitle>
          <DialogDescription>
            Review by{' '}
            <span className='font-semibold'>{currentRow.userName}</span> for{' '}
            {currentRow.venueName} — rated {currentRow.rating.toFixed(1)}.
          </DialogDescription>
        </DialogHeader>
        <div className='w-full py-1'>
          <Form {...form}>
            <form
              id='review-form'
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-4 p-0.5'
            >
              <FormField
                control={form.control}
                name='action'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Action
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select action'
                      className='col-span-4'
                      items={[
                        { label: 'Approve', value: 'approve' },
                        { label: 'Hide', value: 'hide' },
                        { label: 'Delete', value: 'delete' },
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
                        placeholder='Reason for moderation (optional)'
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
          <Button type='submit' form='review-form'>
            Apply Action
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
