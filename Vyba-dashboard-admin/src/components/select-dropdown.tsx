import { useFormContext } from 'react-hook-form'
import { IconLoader } from '@tabler/icons-react'
import { cn } from '@/lib/utils'
import { FormControl } from '@/components/ui/form'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'

interface SelectDropdownProps {
  onValueChange?: (value: string) => void
  defaultValue: string | undefined
  placeholder?: string
  isPending?: boolean
  items: { label: string; value: string }[] | undefined
  disabled?: boolean
  className?: string
  isControlled?: boolean
}

export function SelectDropdown({
  defaultValue,
  onValueChange,
  isPending,
  items,
  placeholder,
  disabled,
  className = '',
  isControlled = false,
}: SelectDropdownProps) {
  const defaultState = isControlled
    ? { value: defaultValue, onValueChange }
    : { defaultValue, onValueChange }
  // Reusable both inside a react-hook-form <Form> (e.g. editorial/venues
  // dialogs) and standalone (e.g. curation's plain status filter) — only
  // wrap in <FormControl> when an ancestor <Form> actually exists, since it
  // calls useFormContext() internally and crashes on a null context otherwise.
  const formContext = useFormContext()
  const trigger = (
    <SelectTrigger disabled={disabled} className={cn(className)}>
      <SelectValue placeholder={placeholder ?? 'Select'} />
    </SelectTrigger>
  )
  return (
    <Select {...defaultState}>
      {formContext ? <FormControl>{trigger}</FormControl> : trigger}
      <SelectContent>
        {isPending ? (
          <SelectItem disabled value='loading' className='h-14'>
            <div className='flex items-center justify-center gap-2'>
              <IconLoader className='h-5 w-5 animate-spin' />
              {'  '}
              Loading...
            </div>
          </SelectItem>
        ) : (
          items?.map(({ label, value }) => (
            <SelectItem key={value} value={value}>
              {label}
            </SelectItem>
          ))
        )}
      </SelectContent>
    </Select>
  )
}
