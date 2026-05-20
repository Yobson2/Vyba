import { IconLoader2 } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'

interface FormActionsProps {
  isLoading?: boolean
  submitLabel?: string
  onCancel?: () => void
}

export function FormActions({
  isLoading = false,
  submitLabel = 'Save changes',
  onCancel,
}: FormActionsProps) {
  return (
    <div className='flex items-center gap-3'>
      {onCancel && (
        <Button
          type='button'
          variant='ghost'
          onClick={onCancel}
          disabled={isLoading}
        >
          Cancel
        </Button>
      )}
      <Button type='submit' disabled={isLoading}>
        {isLoading && <IconLoader2 className='mr-2 h-4 w-4 animate-spin' />}
        {submitLabel}
      </Button>
    </div>
  )
}
