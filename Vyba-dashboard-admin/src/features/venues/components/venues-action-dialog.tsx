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
import { SelectDropdown } from '@/components/select-dropdown'
import {
  useCreateVenueMutation,
  useUpdateVenueMutation,
} from '../api/venues-api'
import { priceLevels, statusOptions, venueTypes } from '../data/data'
import { Venue } from '../data/schema'

const formSchema = z.object({
  name: z.string().min(2, { message: 'Name is required.' }),
  description: z.string().optional(),
  address: z.string().optional(),
  latitude: z
    .string()
    .min(1, { message: 'Latitude is required.' })
    .refine(
      (v) => !Number.isNaN(Number(v)) && Number(v) >= -90 && Number(v) <= 90,
      {
        message: 'Enter a valid latitude (-90 to 90).',
      }
    ),
  longitude: z
    .string()
    .min(1, { message: 'Longitude is required.' })
    .refine(
      (v) => !Number.isNaN(Number(v)) && Number(v) >= -180 && Number(v) <= 180,
      { message: 'Enter a valid longitude (-180 to 180).' }
    ),
  venueType: z.string().min(1, { message: 'Venue type is required.' }),
  priceLevel: z.string().min(1, { message: 'Price level is required.' }),
  validationStatus: z.string().min(1, { message: 'Status is required.' }),
})
type VenueForm = z.infer<typeof formSchema>

interface Props {
  currentRow?: Venue
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function VenuesActionDialog({ currentRow, open, onOpenChange }: Props) {
  const isEdit = !!currentRow
  const createVenue = useCreateVenueMutation()
  const updateVenue = useUpdateVenueMutation()
  const isPending = createVenue.isPending || updateVenue.isPending

  const form = useForm<VenueForm>({
    resolver: zodResolver(formSchema),
    defaultValues: isEdit
      ? {
          name: currentRow.name,
          description: currentRow.description ?? '',
          address: currentRow.address ?? '',
          latitude: String(currentRow.latitude),
          longitude: String(currentRow.longitude),
          venueType: currentRow.venueType,
          priceLevel: String(currentRow.priceLevel),
          validationStatus: currentRow.validationStatus,
        }
      : {
          name: '',
          description: '',
          address: '',
          latitude: '',
          longitude: '',
          venueType: '',
          priceLevel: '',
          validationStatus: 'ONBOARDING',
        },
  })

  const onSubmit = (values: VenueForm) => {
    const payload = {
      name: values.name,
      description: values.description || undefined,
      address: values.address || undefined,
      latitude: Number(values.latitude),
      longitude: Number(values.longitude),
      venueType: values.venueType as Venue['venueType'],
      priceLevel: Number(values.priceLevel),
    }

    const onSuccess = () => {
      form.reset()
      toast.success(isEdit ? 'Venue updated' : 'Venue created', {
        description: `${values.name} (${values.venueType})`,
      })
      onOpenChange(false)
    }
    const onError = () => {
      toast.error(isEdit ? 'Failed to update venue' : 'Failed to create venue')
    }

    if (isEdit) {
      updateVenue.mutate(
        {
          id: currentRow.id,
          ...payload,
          validationStatus:
            values.validationStatus as Venue['validationStatus'],
        },
        { onSuccess, onError }
      )
    } else {
      createVenue.mutate(payload, { onSuccess, onError })
    }
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
                        placeholder='Le Boony'
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
                        placeholder='Rue du Canal, Zone 4, Marcory'
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
                name='latitude'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Latitude
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='5.286'
                        inputMode='decimal'
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
                name='longitude'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Longitude
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder='-3.986'
                        inputMode='decimal'
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
              {isEdit && (
                <FormField
                  control={form.control}
                  name='validationStatus'
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
                        items={statusOptions.map(({ label, value }) => ({
                          label,
                          value,
                        }))}
                      />
                      <FormMessage className='col-span-4 col-start-3' />
                    </FormItem>
                  )}
                />
              )}
            </form>
          </Form>
        </div>
        <DialogFooter>
          <Button type='submit' form='venue-form' disabled={isPending}>
            {isEdit ? 'Save changes' : 'Create venue'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
