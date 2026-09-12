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
import { useBindOwnerMutation } from '../api/venues-api'
import { Venue } from '../data/schema'

/** E.164: a leading '+', a non-zero first digit, then 6-14 more digits — matches the backend contract. */
const E164_REGEX = /^\+[1-9]\d{6,14}$/

const formSchema = z.object({
  phone: z.string().regex(E164_REGEX, {
    message: 'Enter a valid E.164 phone number, e.g. +2250700000001.',
  }),
  firstName: z.string().optional(),
  lastName: z.string().optional(),
})
type OwnerForm = z.infer<typeof formSchema>

interface Props {
  currentRow: Venue
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function VenuesOwnerDialog({ currentRow, open, onOpenChange }: Props) {
  const isRebind = !!currentRow.owner
  const bindOwner = useBindOwnerMutation()

  const form = useForm<OwnerForm>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      phone: currentRow.owner?.phone ?? '',
      firstName: currentRow.owner?.firstName ?? '',
      lastName: currentRow.owner?.lastName ?? '',
    },
  })

  const onSubmit = (values: OwnerForm) => {
    bindOwner.mutate(
      {
        id: currentRow.id,
        phone: values.phone,
        firstName: values.firstName || undefined,
        lastName: values.lastName || undefined,
      },
      {
        onSuccess: () => {
          form.reset()
          toast.success(isRebind ? 'Owner re-bound' : 'Owner bound', {
            description: `${values.phone} → ${currentRow.name}`,
          })
          onOpenChange(false)
        },
        onError: () => {
          toast.error('Failed to bind owner')
        },
      }
    )
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(state) => {
        form.reset()
        onOpenChange(state)
      }}
    >
      <DialogContent className='sm:max-w-md'>
        <DialogHeader className='text-left'>
          <DialogTitle>
            {isRebind ? 'Re-bind Owner' : 'Créer / lier un compte propriétaire'}
          </DialogTitle>
          <DialogDescription>
            Provisions a VENUE_OWNER account by phone number and binds it to{' '}
            <span className='font-medium'>{currentRow.name}</span>. No password
            — the owner signs in with phone + a one-time code.
          </DialogDescription>
        </DialogHeader>
        <Form {...form}>
          <form
            id='venue-owner-form'
            onSubmit={form.handleSubmit(onSubmit)}
            className='space-y-4 p-0.5'
          >
            <FormField
              control={form.control}
              name='phone'
              render={({ field }) => (
                <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                  <FormLabel className='col-span-2 text-right'>Phone</FormLabel>
                  <FormControl>
                    <Input
                      placeholder='+2250700000001'
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
              name='firstName'
              render={({ field }) => (
                <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                  <FormLabel className='col-span-2 text-right'>
                    First name
                  </FormLabel>
                  <FormControl>
                    <Input
                      placeholder='Awa'
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
              name='lastName'
              render={({ field }) => (
                <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                  <FormLabel className='col-span-2 text-right'>
                    Last name
                  </FormLabel>
                  <FormControl>
                    <Input
                      placeholder='Traoré'
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
        <DialogFooter>
          <Button
            type='submit'
            form='venue-owner-form'
            disabled={bindOwner.isPending}
          >
            {isRebind ? 'Re-bind owner' : 'Bind owner'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
