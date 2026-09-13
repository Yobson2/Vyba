import { HTMLAttributes, useState } from 'react'
import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Link, useNavigate } from '@tanstack/react-router'
import { toast } from 'sonner'
import { isAxiosError } from 'axios'
import api from '@/api/axios-instance'
import { ENDPOINTS } from '@/api/endpoints'
import { useAuthStore } from '@/stores/authStore'
import type { UserRole } from '@/types/roles'
import { decodeJwtPayload } from '@/lib/jwt-utils'
import { cn } from '@/lib/utils'
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
import { PasswordInput } from '@/components/password-input'

type UserAuthFormProps = HTMLAttributes<HTMLFormElement>

const formSchema = z.object({
  email: z
    .string()
    .min(1, { message: 'Please enter your email' })
    .email({ message: 'Invalid email address' }),
  password: z
    .string()
    .min(1, {
      message: 'Please enter your password',
    })
    .min(8, {
      message: 'Password must be at least 8 characters long',
    })
    .regex(/[A-Z]/, {
      message: 'Must contain at least one uppercase letter',
    })
    .regex(/[a-z]/, {
      message: 'Must contain at least one lowercase letter',
    })
    .regex(/[0-9]/, {
      message: 'Must contain at least one digit',
    })
    .regex(/[^A-Za-z0-9]/, {
      message: 'Must contain at least one special character',
    }),
})

export function UserAuthForm({ className, ...props }: UserAuthFormProps) {
  const [isLoading, setIsLoading] = useState(false)
  const navigate = useNavigate()
  const { setAccessToken, setUser } = useAuthStore((s) => s.auth)

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      email: '',
      password: '',
    },
  })

  async function onSubmit(data: z.infer<typeof formSchema>) {
    setIsLoading(true)

    try {
      const res = await api.post<{ accessToken: string }>(
        ENDPOINTS.AUTH.LOGIN,
        data
      )
      const { accessToken } = res.data
      const payload = decodeJwtPayload<{
        userId: string
        role: string
        email?: string
        exp: number
      }>(accessToken)
      if (!payload) {
        throw new Error('Malformed access token')
      }

      setAccessToken(accessToken)
      setUser({
        accountNo: payload.userId,
        email: payload.email ?? data.email,
        role: [payload.role as UserRole],
        exp: payload.exp,
      })

      toast.success('Login successful', {
        description: 'Redirecting to dashboard...',
      })
      navigate({ to: '/dashboard' })
    } catch (error) {
      const description = isAxiosError(error)
        ? ((error.response?.data as { message?: string })?.message ??
          'Invalid email or password.')
        : 'Invalid email or password.'
      toast.error('Login failed', { description })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(onSubmit)}
        className={cn('grid gap-3', className)}
        {...props}
      >
        <FormField
          control={form.control}
          name='email'
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input placeholder='name@example.com' {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name='password'
          render={({ field }) => (
            <FormItem className='relative'>
              <FormLabel>Password</FormLabel>
              <FormControl>
                <PasswordInput placeholder='********' {...field} />
              </FormControl>
              <FormMessage />
              <Link
                to='/forgot-password'
                className='text-muted-foreground absolute -top-0.5 right-0 text-sm font-medium hover:opacity-75'
              >
                Forgot password?
              </Link>
            </FormItem>
          )}
        />
        <Button className='mt-2' disabled={isLoading}>
          Login
        </Button>
      </form>
    </Form>
  )
}
