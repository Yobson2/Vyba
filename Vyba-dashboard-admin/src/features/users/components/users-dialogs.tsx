import { isAxiosError } from 'axios'
import { toast } from 'sonner'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'
import { useUpdateUserMutation } from '../api/users-api'
import { useUsers } from '../context/users-context'
import type { User } from '../data/schema'

function errorMessage(error: unknown, fallback: string) {
  if (isAxiosError(error)) {
    return (error.response?.data as { message?: string })?.message ?? fallback
  }
  return fallback
}

export function UsersDialogs() {
  const { open, setOpen, currentRow } = useUsers()

  return (
    <>
      {currentRow && (
        <DeactivateDialog
          open={open === 'deactivate'}
          onOpenChange={(v) => setOpen(v ? 'deactivate' : null)}
          user={currentRow}
        />
      )}
    </>
  )
}

function DeactivateDialog({
  open,
  onOpenChange,
  user,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  user: User
}) {
  const updateUser = useUpdateUserMutation()
  const action = user.isActive ? 'deactivate' : 'reactivate'
  const name =
    [user.firstName, user.lastName].filter(Boolean).join(' ') || user.phone

  const handleConfirm = () => {
    updateUser.mutate(
      { id: user.id, isActive: !user.isActive },
      {
        onSuccess: () => {
          toast.success(
            action === 'deactivate'
              ? `${name} has been deactivated.`
              : `${name} has been reactivated.`
          )
          onOpenChange(false)
        },
        onError: (error) => {
          toast.error(`Could not ${action} ${name}`, {
            description: errorMessage(error, 'Please try again.'),
          })
        },
      }
    )
  }

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>
            {action === 'deactivate' ? 'Deactivate' : 'Reactivate'} {name}?
          </AlertDialogTitle>
          <AlertDialogDescription>
            {action === 'deactivate'
              ? `This revokes ${name}'s access to the app. You can reactivate them later.`
              : `This restores ${name}'s access to the app.`}
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancel</AlertDialogCancel>
          <AlertDialogAction
            className={
              action === 'deactivate'
                ? 'bg-destructive text-destructive-foreground hover:bg-destructive/90'
                : ''
            }
            onClick={handleConfirm}
            disabled={updateUser.isPending}
          >
            {action === 'deactivate' ? 'Deactivate' : 'Reactivate'}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
