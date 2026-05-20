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
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Checkbox } from '@/components/ui/checkbox'
import { SelectDropdown } from '@/components/select-dropdown'
import { promoTypes } from '../data/data'
import { Promotion } from '../data/schema'

const formSchema = z.object({
  title: z.string().min(2, { message: 'Title is required.' }),
  description: z.string().min(1, { message: 'Description is required.' }),
  promoType: z.string().min(1, { message: 'Promo type is required.' }),
  startDate: z.string().min(1, { message: 'Start date is required.' }),
  endDate: z.string().min(1, { message: 'End date is required.' }),
  isPremiumBoosted: z.boolean(),
  status: z.string().min(1, { message: 'Status is required.' }),
})
type PromotionForm = z.infer<typeof formSchema>

interface Props {
  currentRow: Promotion
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function PromotionsActionDialog({
  currentRow,
  open,
  onOpenChange,
}: Props) {
  const form = useForm<PromotionForm>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: currentRow.title,
      description: currentRow.description,
      promoType: currentRow.promoType,
      startDate: currentRow.startDate.toISOString().split('T')[0],
      endDate: currentRow.endDate.toISOString().split('T')[0],
      isPremiumBoosted: currentRow.isPremiumBoosted,
      status: currentRow.status,
    },
  })

  const onSubmit = (values: PromotionForm) => {
    // TODO: Replace with real API call
    form.reset()
    toast.success('Promotion updated', {
      description: `"${values.title}" has been updated.`,
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
          <DialogTitle>Edit Promotion</DialogTitle>
          <DialogDescription>
            Update promotion details for{' '}
            <span className='font-semibold'>{currentRow.title}</span> at{' '}
            {currentRow.venueName}.
          </DialogDescription>
        </DialogHeader>
        <div className='-mr-4 h-[26.25rem] w-full overflow-y-auto py-1 pr-4'>
          <Form {...form}>
            <form
              id='promotion-form'
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-4 p-0.5'
            >
              <FormField
                control={form.control}
                name='title'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Title
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='Friday Happy Hour'
                        className='col-span-4'
                        autoComplete='off'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='description'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Description
                    </FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder='Describe the promotion'
                        className='col-span-4'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='promoType'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Type
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select type'
                      className='col-span-4'
                      items={promoTypes.map(({ label, value }) => ({
                        label,
                        value,
                      }))}
                    />
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='startDate'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Start Date
                    </FormLabel>
                    <FormControl>
                      <Input
                        type='date'
                        className='col-span-4'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='endDate'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      End Date
                    </FormLabel>
                    <FormControl>
                      <Input
                        type='date'
                        className='col-span-4'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
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
                        { label: 'Active', value: 'active' },
                        { label: 'Scheduled', value: 'scheduled' },
                        { label: 'Expired', value: 'expired' },
                        { label: 'Pending', value: 'pending' },
                        { label: 'Rejected', value: 'rejected' },
                      ]}
                    />
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='isPremiumBoosted'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Boosted
                    </FormLabel>
                    <div className='col-span-4 flex items-center gap-x-2'>
                      <Checkbox
                        checked={field.value}
                        onCheckedChange={field.onChange}
                      />
                      <span className='text-sm text-muted-foreground'>
                        Premium boosted promotion
                      </span>
                    </div>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
            </form>
          </Form>
        </div>
        <DialogFooter>
          <Button type='submit' form='promotion-form'>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
