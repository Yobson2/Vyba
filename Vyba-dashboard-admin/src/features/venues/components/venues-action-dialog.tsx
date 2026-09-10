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
import { Switch } from '@/components/ui/switch'
import { SelectDropdown } from '@/components/select-dropdown'
import { venueTypes, priceLevels } from '../data/data'
import { Venue } from '../data/schema'

const formSchema = z.object({
  name: z.string().min(2, { message: 'Name is required.' }),
  description: z.string().min(1, { message: 'Description is required.' }),
  address: z.string().min(1, { message: 'Address is required.' }),
  venueType: z.string().min(1, { message: 'Venue type is required.' }),
  priceLevel: z.string().min(1, { message: 'Price level is required.' }),
  city: z.string().min(1, { message: 'City is required.' }),
  isPremium: z.boolean(),
  status: z.string().min(1, { message: 'Status is required.' }),
  ownerName: z.string().min(1, { message: 'Owner name is required.' }),
})
type VenueForm = z.infer<typeof formSchema>

interface Props {
  currentRow?: Venue
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function VenuesActionDialog({ currentRow, open, onOpenChange }: Props) {
  const isEdit = !!currentRow
  const form = useForm<VenueForm>({
    resolver: zodResolver(formSchema),
    defaultValues: isEdit
      ? {
          name: currentRow.name,
          description: currentRow.description,
          address: currentRow.address,
          venueType: currentRow.venueType,
          priceLevel: String(currentRow.priceLevel),
          city: currentRow.city,
          isPremium: currentRow.isPremium,
          status: currentRow.status,
          ownerName: currentRow.ownerName,
        }
      : {
          name: '',
          description: '',
          address: '',
          venueType: '',
          priceLevel: '',
          city: 'Abidjan',
          isPremium: false,
          status: 'active',
          ownerName: '',
        },
  })

  const onSubmit = (values: VenueForm) => {
    // TODO: Replace with real API call
    form.reset()
    toast.success(isEdit ? 'Venue updated' : 'Venue created', {
      description: `${values.name} (${values.venueType})`,
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
          <DialogTitle>{isEdit ? 'Edit Venue' : 'Add Venue'}</DialogTitle>
          <DialogDescription>
            {isEdit
              ? 'Update venue details and status.'
              : 'Add a new venue to the platform.'}
          </DialogDescription>
        </DialogHeader>
        <div className='-mr-4 h-[26.25rem] w-full overflow-y-auto py-1 pr-4'>
          <Form {...form}>
            <form
              id='venue-form'
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-4 p-0.5'
            >
              <FormField
                control={form.control}
                name='name'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Name
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='Club Quilox'
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
                        placeholder='Describe the venue...'
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
                name='address'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Address
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='123 Admiralty Way, Lekki'
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
                name='venueType'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Type
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select a type'
                      className='col-span-4'
                      items={venueTypes.map(({ label, value }) => ({
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
                name='priceLevel'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Price Level
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select price level'
                      className='col-span-4'
                      items={priceLevels.map(({ label, value }) => ({
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
                name='city'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      City
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Select city'
                      className='col-span-4'
                      items={[
                        { label: 'Abidjan', value: 'Abidjan' },
                        { label: 'Abuja', value: 'Abuja' },
                        { label: 'Port Harcourt', value: 'Port Harcourt' },
                        { label: 'Ibadan', value: 'Ibadan' },
                        { label: 'Kano', value: 'Kano' },
                      ]}
                    />
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
                        { label: 'Pending', value: 'pending' },
                        { label: 'Suspended', value: 'suspended' },
                        { label: 'Rejected', value: 'rejected' },
                      ]}
                    />
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='ownerName'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Owner
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='Adeola Johnson'
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
                name='isPremium'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Premium
                    </FormLabel>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
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
          <Button type='submit' form='venue-form'>
            {isEdit ? 'Save changes' : 'Create venue'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
