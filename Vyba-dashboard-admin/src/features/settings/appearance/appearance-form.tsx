import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { IconCheck } from '@tabler/icons-react'
import { toast } from 'sonner'
import { cn } from '@/lib/utils'
import { useTheme } from '@/context/theme-context'
import { Button } from '@/components/ui/button'
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { SettingsCard } from '../components/settings-card'

const appearanceFormSchema = z.object({
  theme: z.enum(['light', 'dark', 'system'], {
    required_error: 'Please select a theme.',
  }),
})

type AppearanceFormValues = z.infer<typeof appearanceFormSchema>

const themeOptions = [
  {
    value: 'light' as const,
    label: 'Light',
    previewClass: 'bg-[hsl(210_40%_96.1%)]',
    cardClass: 'bg-white',
    skeletonClass: 'bg-[hsl(210_40%_90%)]',
  },
  {
    value: 'dark' as const,
    label: 'Dark',
    previewClass: 'bg-[hsl(218_50%_8%)]',
    cardClass: 'bg-[hsl(218_50%_15%)]',
    skeletonClass: 'bg-[hsl(218_30%_30%)]',
  },
  {
    value: 'system' as const,
    label: 'System',
    previewClass:
      'bg-gradient-to-r from-[hsl(210_40%_96.1%)] to-[hsl(218_50%_8%)]',
    cardClass:
      'bg-gradient-to-r from-white to-[hsl(218_50%_15%)]',
    skeletonClass:
      'bg-gradient-to-r from-[hsl(210_40%_90%)] to-[hsl(218_30%_30%)]',
  },
]

export function AppearanceForm() {
  const { theme, setTheme } = useTheme()

  const defaultValues: AppearanceFormValues = {
    theme: (theme as 'light' | 'dark' | 'system') ?? 'dark',
  }

  const form = useForm<AppearanceFormValues>({
    resolver: zodResolver(appearanceFormSchema),
    defaultValues,
  })

  function onSubmit(data: AppearanceFormValues) {
    if (data.theme !== theme) setTheme(data.theme)
    toast.success('Appearance updated.')
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-6'>
        <SettingsCard
          title='Theme'
          description='Select the theme for the dashboard.'
        >
          <FormField
            control={form.control}
            name='theme'
            render={({ field }) => (
              <FormItem className='space-y-1'>
                <FormMessage />
                <RadioGroup
                  onValueChange={field.onChange}
                  defaultValue={field.value}
                  className='grid max-w-lg grid-cols-3 gap-4'
                >
                  {themeOptions.map((option) => (
                    <FormItem key={option.value}>
                      <FormLabel className='cursor-pointer [&:has([data-state=checked])>div]:ring-primary [&:has([data-state=checked])>div]:ring-2'>
                        <FormControl>
                          <RadioGroupItem
                            value={option.value}
                            className='sr-only'
                          />
                        </FormControl>
                        <div className='relative items-center rounded-lg p-1 transition-all hover:opacity-80'>
                          <div
                            className={cn(
                              'space-y-2 rounded-md p-2',
                              option.previewClass
                            )}
                          >
                            <div
                              className={cn(
                                'space-y-2 rounded-md p-2',
                                option.cardClass
                              )}
                            >
                              <div
                                className={cn(
                                  'h-2 w-[60%] rounded-lg',
                                  option.skeletonClass
                                )}
                              />
                              <div
                                className={cn(
                                  'h-2 w-[80%] rounded-lg',
                                  option.skeletonClass
                                )}
                              />
                            </div>
                            <div
                              className={cn(
                                'flex items-center space-x-2 rounded-md p-2',
                                option.cardClass
                              )}
                            >
                              <div
                                className={cn(
                                  'h-4 w-4 rounded-full',
                                  option.skeletonClass
                                )}
                              />
                              <div
                                className={cn(
                                  'h-2 w-[70%] rounded-lg',
                                  option.skeletonClass
                                )}
                              />
                            </div>
                          </div>
                          {field.value === option.value && (
                            <div className='bg-primary absolute top-2 right-2 rounded-full p-0.5'>
                              <IconCheck size={12} className='text-primary-foreground' />
                            </div>
                          )}
                        </div>
                        <span className='block w-full p-2 text-center text-sm font-normal'>
                          {option.label}
                        </span>
                      </FormLabel>
                    </FormItem>
                  ))}
                </RadioGroup>
                <FormDescription className='pt-2'>
                  Choose "System" to automatically match your operating system
                  preference.
                </FormDescription>
              </FormItem>
            )}
          />
        </SettingsCard>

        <Button type='submit'>Update appearance</Button>
      </form>
    </Form>
  )
}
