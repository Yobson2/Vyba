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
} from '@/components/ui/form'
import { Switch } from '@/components/ui/switch'
import { SettingsCard } from '../components/settings-card'
import { FormActions } from '../components/form-actions'

const notificationsFormSchema = z.object({
  new_bookings: z.boolean(),
  venue_applications: z.boolean(),
  flagged_reviews: z.boolean(),
  system_alerts: z.boolean(),
  daily_summary: z.boolean(),
  security_alerts: z.boolean(),
  weekly_analytics: z.boolean(),
})

type NotificationsFormValues = z.infer<typeof notificationsFormSchema>

const defaultValues: NotificationsFormValues = {
  new_bookings: true,
  venue_applications: true,
  flagged_reviews: true,
  system_alerts: true,
  daily_summary: false,
  security_alerts: true,
  weekly_analytics: false,
}

interface NotificationSwitchProps {
  name: keyof NotificationsFormValues
  label: string
  description: string
  disabled?: boolean
  control: ReturnType<typeof useForm<NotificationsFormValues>>['control']
}

function NotificationSwitch({
  name,
  label,
  description,
  disabled,
  control,
}: NotificationSwitchProps) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem className='flex flex-row items-center justify-between rounded-xl bg-muted/30 p-4'>
          <div className='space-y-0.5'>
            <FormLabel className='text-base'>{label}</FormLabel>
            <FormDescription>{description}</FormDescription>
          </div>
          <FormControl>
            <Switch
              checked={field.value}
              onCheckedChange={field.onChange}
              disabled={disabled}
              aria-readonly={disabled}
            />
          </FormControl>
        </FormItem>
      )}
    />
  )
}

export function NotificationsForm() {
  const form = useForm<NotificationsFormValues>({
    resolver: zodResolver(notificationsFormSchema),
    defaultValues,
  })

  function onSubmit(_data: NotificationsFormValues) {
    toast.success('Notification preferences updated.')
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-6'>
        <SettingsCard
          title='In-App Notifications'
          description='Get notified about activity on the platform.'
        >
          <div className='space-y-3'>
            <NotificationSwitch
              name='new_bookings'
              label='New bookings'
              description='Get notified when a booking is made on the platform.'
              control={form.control}
            />
            <NotificationSwitch
              name='venue_applications'
              label='Venue applications'
              description='Get notified when a venue owner submits a new application.'
              control={form.control}
            />
            <NotificationSwitch
              name='flagged_reviews'
              label='Flagged reviews'
              description='Get notified when a review is flagged for moderation.'
              control={form.control}
            />
            <NotificationSwitch
              name='system_alerts'
              label='System alerts'
              description='Receive alerts about platform health and maintenance.'
              control={form.control}
            />
          </div>
        </SettingsCard>

        <SettingsCard
          title='Email Notifications'
          description='Manage email digests and alerts.'
        >
          <div className='space-y-3'>
            <NotificationSwitch
              name='daily_summary'
              label='Daily summary'
              description='Receive a daily email digest of platform activity.'
              control={form.control}
            />
            <NotificationSwitch
              name='security_alerts'
              label='Security alerts'
              description='Receive emails about suspicious activity and sign-ins.'
              disabled
              control={form.control}
            />
            <NotificationSwitch
              name='weekly_analytics'
              label='Weekly analytics'
              description='Receive a weekly summary of key platform metrics.'
              control={form.control}
            />
          </div>
        </SettingsCard>

        <FormActions submitLabel='Update notifications' />
      </form>
    </Form>
  )
}
