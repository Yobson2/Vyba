import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { SettingsCard } from '../components/settings-card'
import { FormActions } from '../components/form-actions'

const regionalFormSchema = z.object({
  timezone: z.string(),
  dateFormat: z.string(),
  currency: z.string(),
})

type RegionalFormValues = z.infer<typeof regionalFormSchema>

const defaultValues: RegionalFormValues = {
  timezone: 'Africa/Abidjan',
  dateFormat: 'DD/MM/YYYY',
  currency: 'NGN',
}

export function RegionalForm() {
  const form = useForm<RegionalFormValues>({
    resolver: zodResolver(regionalFormSchema),
    defaultValues,
  })

  function onSubmit(_data: RegionalFormValues) {
    toast.success('Regional settings updated.')
  }

  return (
    <SettingsCard
      title='Regional Settings'
      description='Configure how dates, times, and currency display across the dashboard.'
    >
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-4'>
          <FormField
            control={form.control}
            name='timezone'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Timezone</FormLabel>
                <Select
                  onValueChange={field.onChange}
                  defaultValue={field.value}
                >
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue placeholder='Select timezone' />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectItem value='Africa/Abidjan'>
                      Africa/Abidjan (WAT, UTC+1)
                    </SelectItem>
                    <SelectItem value='Europe/London'>
                      Europe/London (GMT, UTC+0)
                    </SelectItem>
                    <SelectItem value='America/New_York'>
                      America/New_York (EST, UTC-5)
                    </SelectItem>
                    <SelectItem value='Europe/Paris'>
                      Europe/Paris (CET, UTC+1)
                    </SelectItem>
                    <SelectItem value='Asia/Dubai'>
                      Asia/Dubai (GST, UTC+4)
                    </SelectItem>
                  </SelectContent>
                </Select>
                <FormDescription>
                  All timestamps in the dashboard will use this timezone.
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name='dateFormat'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Date format</FormLabel>
                <Select
                  onValueChange={field.onChange}
                  defaultValue={field.value}
                >
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue placeholder='Select date format' />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectItem value='DD/MM/YYYY'>
                      DD/MM/YYYY (20/05/2026)
                    </SelectItem>
                    <SelectItem value='MM/DD/YYYY'>
                      MM/DD/YYYY (05/20/2026)
                    </SelectItem>
                    <SelectItem value='YYYY-MM-DD'>
                      YYYY-MM-DD (2026-05-20)
                    </SelectItem>
                  </SelectContent>
                </Select>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name='currency'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Currency</FormLabel>
                <Select
                  onValueChange={field.onChange}
                  defaultValue={field.value}
                >
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue placeholder='Select currency' />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectItem value='NGN'>NGN — Nigerian Naira</SelectItem>
                    <SelectItem value='USD'>USD — US Dollar</SelectItem>
                    <SelectItem value='GBP'>GBP — British Pound</SelectItem>
                    <SelectItem value='EUR'>EUR — Euro</SelectItem>
                  </SelectContent>
                </Select>
                <FormDescription>
                  Prices and revenue data will display in this currency.
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormActions submitLabel='Save regional settings' />
        </form>
      </Form>
    </SettingsCard>
  )
}
