import { useState } from 'react'
import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { isAxiosError } from 'axios'
import { toast } from 'sonner'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { Button } from '@/components/ui/button'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { PasswordInput } from '@/components/password-input'
import { SettingsCard } from '../components/settings-card'

const passwordSchema = z
  .string()
  .min(8, { message: 'Must be at least 8 characters long' })
  .regex(/[A-Z]/, { message: 'Must contain at least one uppercase letter' })
  .regex(/[a-z]/, { message: 'Must contain at least one lowercase letter' })
  .regex(/[0-9]/, { message: 'Must contain at least one digit' })
  .regex(/[^A-Za-z0-9]/, {
    message: 'Must contain at least one special character',
  })

const formSchema = z
  .object({
    currentPassword: z.string().min(1, { message: 'Required' }),
    newPassword: passwordSchema,
    confirmPassword: z.string().min(1, { message: 'Required' }),
  })
  .refine((data) => data.newPassword === data.confirmPassword, {
    message: "Passwords don't match",
    path: ['confirmPassword'],
  })

type FormValues = z.infer<typeof formSchema>

export function ChangePasswordForm() {
  const [isLoading, setIsLoading] = useState(false)

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
    },
  })

  async function onSubmit(data: FormValues) {
    setIsLoading(true)
    try {
      await api.patch(ENDPOINTS.AUTH.CHANGE_PASSWORD, {
        currentPassword: data.currentPassword,
        newPassword: data.newPassword,
      })
      toast.success('Password updated.')
      form.reset()
    } catch (error) {
      const description = isAxiosError(error)
        ? ((error.response?.data as { message?: string })?.message ??
          'Could not update your password.')
        : 'Could not update your password.'
      toast.error('Update failed', { description })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-6'>
        <SettingsCard
          title='Password'
          description='Change the password for your admin account.'
        >
          <div className='max-w-sm space-y-4'>
            <FormField
              control={form.control}
              name='currentPassword'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Current password</FormLabel>
                  <FormControl>
                    <PasswordInput placeholder='********' {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name='newPassword'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>New password</FormLabel>
                  <FormControl>
                    <PasswordInput placeholder='********' {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name='confirmPassword'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Confirm new password</FormLabel>
                  <FormControl>
                    <PasswordInput placeholder='********' {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </SettingsCard>

        <Button type='submit' disabled={isLoading}>
          Update password
        </Button>
      </form>
    </Form>
  )
}
