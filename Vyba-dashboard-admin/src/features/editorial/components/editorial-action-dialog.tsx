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
import { Switch } from '@/components/ui/switch'
import { Textarea } from '@/components/ui/textarea'
import { SelectDropdown } from '@/components/select-dropdown'
import { useVenuesQuery } from '@/features/venues/api/venues-api'
import {
  useCreateEditorialMutation,
  useUpdateEditorialMutation,
} from '../api/editorial-api'
import { EditorialItem } from '../data/schema'

/** `datetime-local` has no timezone; Abidjan is UTC+0 year-round (ADR) so this is already correct. */
function toDatetimeLocal(date: Date): string {
  return date.toISOString().slice(0, 16)
}

function defaultExpiry(): string {
  const d = new Date()
  d.setDate(d.getDate() + 1)
  return toDatetimeLocal(d)
}

const formSchema = z.object({
  title: z.string().min(2, { message: 'Title is required.' }).max(120),
  body: z.string().min(2, { message: 'Body is required.' }).max(2000),
  venueId: z.string(),
  publishedAt: z.string().optional(),
  expiresAt: z.string().min(1, { message: 'Expiry is required.' }),
  draft: z.boolean(),
})
type EditorialForm = z.infer<typeof formSchema>

const AREA_WIDE = '__area_wide__'

interface Props {
  currentRow?: EditorialItem
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function EditorialActionDialog({
  currentRow,
  open,
  onOpenChange,
}: Props) {
  const isEdit = !!currentRow
  const { data: venues } = useVenuesQuery()
  const createEditorial = useCreateEditorialMutation()
  const updateEditorial = useUpdateEditorialMutation()
  const isPending = createEditorial.isPending || updateEditorial.isPending

  const form = useForm<EditorialForm>({
    resolver: zodResolver(formSchema),
    defaultValues: isEdit
      ? {
          title: currentRow.payload.title,
          body: currentRow.payload.body,
          venueId: currentRow.venueId ?? AREA_WIDE,
          publishedAt: toDatetimeLocal(currentRow.publishedAt),
          expiresAt: currentRow.expiresAt
            ? toDatetimeLocal(currentRow.expiresAt)
            : defaultExpiry(),
          draft: currentRow.status === 'DRAFT',
        }
      : {
          title: '',
          body: '',
          venueId: AREA_WIDE,
          publishedAt: '',
          expiresAt: defaultExpiry(),
          draft: false,
        },
  })

  const onSubmit = (values: EditorialForm) => {
    const venueId = values.venueId === AREA_WIDE ? undefined : values.venueId

    const onSuccess = () => {
      form.reset()
      toast.success(
        isEdit ? 'Editorial item updated' : 'Editorial item created'
      )
      onOpenChange(false)
    }
    const onError = () => {
      toast.error(isEdit ? 'Failed to update item' : 'Failed to create item')
    }

    if (isEdit) {
      updateEditorial.mutate(
        {
          id: currentRow.id,
          title: values.title,
          body: values.body,
          venueId: venueId ?? null,
          publishedAt: values.publishedAt
            ? new Date(values.publishedAt).toISOString()
            : undefined,
          expiresAt: new Date(values.expiresAt).toISOString(),
        },
        { onSuccess, onError }
      )
    } else {
      createEditorial.mutate(
        {
          title: values.title,
          body: values.body,
          venueId,
          publishedAt: values.publishedAt
            ? new Date(values.publishedAt).toISOString()
            : undefined,
          expiresAt: new Date(values.expiresAt).toISOString(),
          draft: values.draft,
        },
        { onSuccess, onError }
      )
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
          <DialogTitle>
            {isEdit ? 'Edit editorial item' : 'New editorial item'}
          </DialogTitle>
          <DialogDescription>
            {isEdit
              ? 'Update the title, body, association or timing.'
              : '"Ce soir à Zone 4", "5 spots chauds ce soir" — area-wide or tied to one venue.'}
          </DialogDescription>
        </DialogHeader>
        <div className='-mr-4 max-h-[26.25rem] w-full overflow-y-auto py-1 pr-4'>
          <Form {...form}>
            <form
              id='editorial-form'
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
                        placeholder='Ce soir à Zone 4'
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
                name='body'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Body
                    </FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder='5 spots chauds ce soir, à commencer par...'
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
                name='venueId'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Association
                    </FormLabel>
                    <SelectDropdown
                      defaultValue={field.value}
                      onValueChange={field.onChange}
                      placeholder='Area-wide'
                      className='col-span-4'
                      items={[
                        {
                          label: 'Area-wide (not tied to a venue)',
                          value: AREA_WIDE,
                        },
                        ...(venues ?? []).map((v) => ({
                          label: v.name,
                          value: v.id,
                        })),
                      ]}
                    />
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='publishedAt'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Publish at
                    </FormLabel>
                    <FormControl>
                      <Input
                        type='datetime-local'
                        className='col-span-4'
                        placeholder='Now'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name='expiresAt'
                render={({ field }) => (
                  <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                    <FormLabel className='col-span-2 text-right'>
                      Expires at
                    </FormLabel>
                    <FormControl>
                      <Input
                        type='datetime-local'
                        className='col-span-4'
                        {...field}
                      />
                    </FormControl>
                    <FormMessage className='col-span-4 col-start-3' />
                  </FormItem>
                )}
              />
              {!isEdit && (
                <FormField
                  control={form.control}
                  name='draft'
                  render={({ field }) => (
                    <FormItem className='grid grid-cols-6 items-center space-y-0 gap-x-4 gap-y-1'>
                      <FormLabel className='col-span-2 text-right'>
                        Save as draft
                      </FormLabel>
                      <FormControl>
                        <Switch
                          checked={field.value}
                          onCheckedChange={field.onChange}
                          className='col-span-4 justify-self-start'
                        />
                      </FormControl>
                    </FormItem>
                  )}
                />
              )}
            </form>
          </Form>
        </div>
        <DialogFooter>
          <Button type='submit' form='editorial-form' disabled={isPending}>
            {isEdit ? 'Save changes' : 'Create item'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
