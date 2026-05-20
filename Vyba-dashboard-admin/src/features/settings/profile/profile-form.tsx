import { z } from 'zod'
import { useFieldArray, useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { CaretSortIcon, CheckIcon } from '@radix-ui/react-icons'
import { IconPlus, IconTrash } from '@tabler/icons-react'
import { cn } from '@/lib/utils'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from '@/components/ui/command'
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'
import { Textarea } from '@/components/ui/textarea'
import { SettingsCard } from '../components/settings-card'
import { FormActions } from '../components/form-actions'

const languages = [
  { label: 'English', value: 'en' },
  { label: 'French', value: 'fr' },
  { label: 'Portuguese', value: 'pt' },
  { label: 'Yoruba', value: 'yo' },
  { label: 'Pidgin', value: 'pcm' },
  { label: 'Spanish', value: 'es' },
] as const

const timezones = [
  { label: 'Africa/Lagos (WAT)', value: 'Africa/Lagos' },
  { label: 'Europe/London (GMT)', value: 'Europe/London' },
  { label: 'America/New_York (EST)', value: 'America/New_York' },
  { label: 'Europe/Paris (CET)', value: 'Europe/Paris' },
  { label: 'Asia/Dubai (GST)', value: 'Asia/Dubai' },
] as const

const profileFormSchema = z.object({
  displayName: z
    .string()
    .min(2, 'Display name must be at least 2 characters.')
    .max(50, 'Display name must not exceed 50 characters.'),
  email: z.string().email(),
  bio: z
    .string()
    .max(250, 'Bio must not exceed 250 characters.')
    .optional()
    .or(z.literal('')),
  language: z.string({
    required_error: 'Please select a language.',
  }),
  timezone: z.string({
    required_error: 'Please select a timezone.',
  }),
  urls: z
    .array(
      z.object({
        value: z.string().url({ message: 'Please enter a valid URL.' }),
      })
    )
    .optional(),
})

type ProfileFormValues = z.infer<typeof profileFormSchema>

const defaultValues: Partial<ProfileFormValues> = {
  displayName: 'Admin',
  email: 'admin@vyba.app',
  bio: 'Vyba platform administrator.',
  language: 'en',
  timezone: 'Africa/Lagos',
  urls: [{ value: 'https://vyba.app' }],
}

export default function ProfileForm() {
  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileFormSchema),
    defaultValues,
    mode: 'onChange',
  })

  const { fields, append, remove } = useFieldArray({
    name: 'urls',
    control: form.control,
  })

  function onSubmit(_data: ProfileFormValues) {
    toast.success('Profile updated successfully.')
  }

  const bioValue = form.watch('bio') ?? ''

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-6'>
        {/* Personal Information */}
        <SettingsCard
          title='Personal Information'
          description='Your public profile details.'
        >
          <div className='space-y-6'>
            <FormField
              control={form.control}
              name='displayName'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Display name</FormLabel>
                  <FormControl>
                    <Input placeholder='Your name' {...field} />
                  </FormControl>
                  <FormDescription>
                    This name is visible to other admins on the platform.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name='email'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Email address</FormLabel>
                  <FormControl>
                    <Input {...field} disabled className='opacity-70' />
                  </FormControl>
                  <FormDescription>
                    Contact your super admin to change your email address.
                  </FormDescription>
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name='bio'
              render={({ field }) => (
                <FormItem>
                  <div className='flex items-center justify-between'>
                    <FormLabel>Bio</FormLabel>
                    <span className='text-muted-foreground text-xs'>
                      {bioValue.length}/250
                    </span>
                  </div>
                  <FormControl>
                    <Textarea
                      placeholder='Brief description for your admin profile'
                      className='resize-none'
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </SettingsCard>

        {/* Preferences */}
        <SettingsCard
          title='Preferences'
          description='Language and timezone settings.'
        >
          <div className='grid gap-6 sm:grid-cols-2'>
            <FormField
              control={form.control}
              name='language'
              render={({ field }) => (
                <FormItem className='flex flex-col'>
                  <FormLabel>Language</FormLabel>
                  <Popover>
                    <PopoverTrigger asChild>
                      <FormControl>
                        <Button
                          variant='outline'
                          role='combobox'
                          className={cn(
                            'w-full justify-between',
                            !field.value && 'text-muted-foreground'
                          )}
                        >
                          {field.value
                            ? languages.find((l) => l.value === field.value)
                                ?.label
                            : 'Select language'}
                          <CaretSortIcon className='ml-2 h-4 w-4 shrink-0 opacity-50' />
                        </Button>
                      </FormControl>
                    </PopoverTrigger>
                    <PopoverContent className='w-[200px] p-0'>
                      <Command>
                        <CommandInput placeholder='Search language...' />
                        <CommandEmpty>No language found.</CommandEmpty>
                        <CommandGroup>
                          <CommandList>
                            {languages.map((language) => (
                              <CommandItem
                                value={language.label}
                                key={language.value}
                                onSelect={() => {
                                  form.setValue('language', language.value)
                                }}
                              >
                                <CheckIcon
                                  className={cn(
                                    'mr-2 h-4 w-4',
                                    language.value === field.value
                                      ? 'opacity-100'
                                      : 'opacity-0'
                                  )}
                                />
                                {language.label}
                              </CommandItem>
                            ))}
                          </CommandList>
                        </CommandGroup>
                      </Command>
                    </PopoverContent>
                  </Popover>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name='timezone'
              render={({ field }) => (
                <FormItem className='flex flex-col'>
                  <FormLabel>Timezone</FormLabel>
                  <Popover>
                    <PopoverTrigger asChild>
                      <FormControl>
                        <Button
                          variant='outline'
                          role='combobox'
                          className={cn(
                            'w-full justify-between',
                            !field.value && 'text-muted-foreground'
                          )}
                        >
                          {field.value
                            ? timezones.find((t) => t.value === field.value)
                                ?.label
                            : 'Select timezone'}
                          <CaretSortIcon className='ml-2 h-4 w-4 shrink-0 opacity-50' />
                        </Button>
                      </FormControl>
                    </PopoverTrigger>
                    <PopoverContent className='w-[260px] p-0'>
                      <Command>
                        <CommandInput placeholder='Search timezone...' />
                        <CommandEmpty>No timezone found.</CommandEmpty>
                        <CommandGroup>
                          <CommandList>
                            {timezones.map((tz) => (
                              <CommandItem
                                value={tz.label}
                                key={tz.value}
                                onSelect={() => {
                                  form.setValue('timezone', tz.value)
                                }}
                              >
                                <CheckIcon
                                  className={cn(
                                    'mr-2 h-4 w-4',
                                    tz.value === field.value
                                      ? 'opacity-100'
                                      : 'opacity-0'
                                  )}
                                />
                                {tz.label}
                              </CommandItem>
                            ))}
                          </CommandList>
                        </CommandGroup>
                      </Command>
                    </PopoverContent>
                  </Popover>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </SettingsCard>

        {/* Links */}
        <SettingsCard
          title='Links'
          description='Add links to your website, blog, or social media profiles.'
        >
          <div className='space-y-3'>
            {fields.map((field, index) => (
              <FormField
                control={form.control}
                key={field.id}
                name={`urls.${index}.value`}
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className={cn(index !== 0 && 'sr-only')}>
                      URL
                    </FormLabel>
                    <div className='flex items-center gap-2'>
                      <FormControl>
                        <Input placeholder='https://...' {...field} />
                      </FormControl>
                      <Button
                        type='button'
                        variant='ghost'
                        size='icon'
                        onClick={() => remove(index)}
                        className='text-muted-foreground hover:text-destructive shrink-0'
                      >
                        <IconTrash size={16} />
                      </Button>
                    </div>
                    <FormMessage />
                  </FormItem>
                )}
              />
            ))}
            <Button
              type='button'
              variant='outline'
              size='sm'
              onClick={() => append({ value: '' })}
            >
              <IconPlus size={16} className='mr-1' />
              Add URL
            </Button>
          </div>
        </SettingsCard>

        <FormActions submitLabel='Update profile' />
      </form>
    </Form>
  )
}
