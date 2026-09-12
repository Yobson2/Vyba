'use client'

import { useState } from 'react'
import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
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
import { useVenuesQuery } from '@/features/venues/api/venues-api'
import { useCreateAssistedPromoMutation } from '../api/assist-api'
import { VenueContentPanel } from './venue-content-panel'

const formSchema = z.object({
  venueId: z.string().min(1, { message: 'Pick a venue.' }),
  title: z.string().min(1, { message: 'Title is required.' }).max(80),
  description: z
    .string()
    .min(1, { message: 'Description is required.' })
    .max(500),
})
type AssistForm = z.infer<typeof formSchema>

/**
 * Team-for-venue assist mode (ticket 13): venue → content type (promo only
 * for now — venue_update/live_tonight have no creation path yet, flagged
 * rather than faked) → the promo form → publish. Never an origin control —
 * `assisted = true` is entirely the backend's call.
 */
export function AssistForm() {
  const { data: venues } = useVenuesQuery()
  const createAssistedPromo = useCreateAssistedPromoMutation()

  const form = useForm<AssistForm>({
    resolver: zodResolver(formSchema),
    defaultValues: { venueId: '', title: '', description: '' },
  })
  const [selectedVenueId, setSelectedVenueId] = useState<string>()

  const onSubmit = (values: AssistForm) => {
    createAssistedPromo.mutate(
      {
        venueId: values.venueId,
        title: values.title,
        description: values.description,
      },
      {
        onSuccess: () => {
          const venueName = venues?.find((v) => v.id === values.venueId)?.name
          form.resetField('title')
          form.resetField('description')
          toast.success('Promo published on behalf of the venue', {
            description: venueName,
          })
        },
        onError: () => toast.error('Failed to publish'),
      }
    )
  }

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(onSubmit)}
        className='max-w-lg space-y-6'
      >
        <FormField
          control={form.control}
          name='venueId'
          render={({ field }) => (
            <FormItem className='space-y-2'>
              <FormLabel>Venue</FormLabel>
              <SelectDropdown
                defaultValue={field.value}
                onValueChange={(value) => {
                  field.onChange(value)
                  setSelectedVenueId(value)
                }}
                placeholder='Pick a venue'
                items={(venues ?? []).map((v) => ({
                  label: v.name,
                  value: v.id,
                }))}
              />
              <FormMessage />
            </FormItem>
          )}
        />

        {selectedVenueId && <VenueContentPanel venueId={selectedVenueId} />}

        <div className='space-y-2'>
          <FormLabel className='text-muted-foreground text-xs uppercase'>
            Content type
          </FormLabel>
          <p className='text-sm'>
            Promo{' '}
            <span className='text-muted-foreground'>
              — venue update and live-tonight assist aren&apos;t available yet.
            </span>
          </p>
        </div>

        <FormField
          control={form.control}
          name='title'
          render={({ field }) => (
            <FormItem className='space-y-2'>
              <FormLabel>Title</FormLabel>
              <FormControl>
                <Input placeholder='Happy hour -50% jusqu’à 23h' {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name='description'
          render={({ field }) => (
            <FormItem className='space-y-2'>
              <FormLabel>Description</FormLabel>
              <FormControl>
                <Textarea
                  placeholder='Sur tous les cocktails, ce soir seulement.'
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <Button type='submit' disabled={createAssistedPromo.isPending}>
          Publish for this venue
        </Button>
      </form>
    </Form>
  )
}
