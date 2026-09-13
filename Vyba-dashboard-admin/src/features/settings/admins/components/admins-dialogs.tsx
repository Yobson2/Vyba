import { useState } from 'react'
import { isAxiosError } from 'axios'
import { IconCopy } from '@tabler/icons-react'
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
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  useCreateAdminMutation,
  useResetAdminPasswordMutation,
  useUpdateAdminMutation,
} from '../api/admins-api'
import { useAdmins } from '../context/admins-context'
import type { Admin } from '../data/schema'

function errorMessage(error: unknown, fallback: string) {
  if (isAxiosError(error)) {
    return (error.response?.data as { message?: string })?.message ?? fallback
  }
  return fallback
}

export function AdminsDialogs() {
  const {
    open,
    setOpen,
    currentRow,
    tempPasswordResult,
    setTempPasswordResult,
  } = useAdmins()

  return (
    <>
      <InviteDialog
        open={open === 'invite'}
        onOpenChange={(v) => setOpen(v ? 'invite' : null)}
      />
      <TempPasswordDialog
        result={tempPasswordResult}
        onOpenChange={(v) => {
          if (!v) setTempPasswordResult(null)
        }}
      />
      {currentRow && (
        <>
          <EditDialog
            open={open === 'edit'}
            onOpenChange={(v) => setOpen(v ? 'edit' : null)}
            admin={currentRow}
          />
          <DeactivateDialog
            open={open === 'deactivate'}
            onOpenChange={(v) => setOpen(v ? 'deactivate' : null)}
            admin={currentRow}
          />
          <ResetPasswordDialog
            open={open === 'reset-password'}
            onOpenChange={(v) => setOpen(v ? 'reset-password' : null)}
            admin={currentRow}
          />
        </>
      )}
    </>
  )
}

/** Shown once right after an invite/reset — the password can never be retrieved again after this closes. */
function TempPasswordDialog({
  result,
  onOpenChange,
}: {
  result: { email: string; temporaryPassword: string } | null
  onOpenChange: (open: boolean) => void
}) {
  const copy = async () => {
    if (!result) return
    await navigator.clipboard.writeText(result.temporaryPassword)
    toast.success('Copied to clipboard')
  }

  return (
    <Dialog open={result !== null} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Temporary password</DialogTitle>
          <DialogDescription>
            Share this with {result?.email} out of band (not by email). It won't
            be shown again — they should change it from Settings → Security
            after signing in.
          </DialogDescription>
        </DialogHeader>
        <div className='flex items-center gap-2 py-2'>
          <code className='bg-muted flex-1 rounded-md px-3 py-2 text-sm break-all'>
            {result?.temporaryPassword}
          </code>
          <Button variant='outline' size='icon' onClick={copy} type='button'>
            <IconCopy size={16} />
          </Button>
        </div>
        <DialogFooter>
          <Button onClick={() => onOpenChange(false)}>Done</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function InviteDialog({
  open,
  onOpenChange,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
}) {
  const [email, setEmail] = useState('')
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const { setTempPasswordResult } = useAdmins()
  const createAdmin = useCreateAdminMutation()

  const handleInvite = () => {
    if (!email.trim()) return
    createAdmin.mutate(
      {
        email: email.trim(),
        firstName: firstName.trim() || undefined,
        lastName: lastName.trim() || undefined,
      },
      {
        onSuccess: (result) => {
          setTempPasswordResult({
            email: result.email,
            temporaryPassword: result.temporaryPassword,
          })
          setEmail('')
          setFirstName('')
          setLastName('')
          onOpenChange(false)
        },
        onError: (error) => {
          toast.error('Could not create admin', {
            description: errorMessage(error, 'Please try again.'),
          })
        },
      }
    )
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Invite Admin</DialogTitle>
          <DialogDescription>
            Creates a dashboard account with a one-time temporary password — no
            invite email is sent, you hand it off yourself.
          </DialogDescription>
        </DialogHeader>
        <div className='space-y-4 py-4'>
          <div className='space-y-2'>
            <Label htmlFor='invite-email'>Email address</Label>
            <Input
              id='invite-email'
              type='email'
              placeholder='teammate@vyba.app'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div className='grid grid-cols-2 gap-3'>
            <div className='space-y-2'>
              <Label htmlFor='invite-first-name'>First name</Label>
              <Input
                id='invite-first-name'
                value={firstName}
                onChange={(e) => setFirstName(e.target.value)}
              />
            </div>
            <div className='space-y-2'>
              <Label htmlFor='invite-last-name'>Last name</Label>
              <Input
                id='invite-last-name'
                value={lastName}
                onChange={(e) => setLastName(e.target.value)}
              />
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button variant='ghost' onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button
            onClick={handleInvite}
            disabled={!email.trim() || createAdmin.isPending}
          >
            Create account
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function EditDialog({
  open,
  onOpenChange,
  admin,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  admin: Admin
}) {
  const [firstName, setFirstName] = useState(admin.firstName ?? '')
  const [lastName, setLastName] = useState(admin.lastName ?? '')
  const updateAdmin = useUpdateAdminMutation()

  const handleSave = () => {
    updateAdmin.mutate(
      {
        id: admin.id,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      },
      {
        onSuccess: () => {
          toast.success('Admin updated.')
          onOpenChange(false)
        },
        onError: (error) => {
          toast.error('Could not update admin', {
            description: errorMessage(error, 'Please try again.'),
          })
        },
      }
    )
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Edit admin</DialogTitle>
          <DialogDescription>{admin.email}</DialogDescription>
        </DialogHeader>
        <div className='grid grid-cols-2 gap-3 py-4'>
          <div className='space-y-2'>
            <Label htmlFor='edit-first-name'>First name</Label>
            <Input
              id='edit-first-name'
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
            />
          </div>
          <div className='space-y-2'>
            <Label htmlFor='edit-last-name'>Last name</Label>
            <Input
              id='edit-last-name'
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant='ghost' onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleSave} disabled={updateAdmin.isPending}>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function DeactivateDialog({
  open,
  onOpenChange,
  admin,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  admin: Admin
}) {
  const updateAdmin = useUpdateAdminMutation()
  const action = admin.isActive ? 'deactivate' : 'reactivate'
  const name =
    [admin.firstName, admin.lastName].filter(Boolean).join(' ') || admin.email

  const handleConfirm = () => {
    updateAdmin.mutate(
      { id: admin.id, isActive: !admin.isActive },
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
              ? `This revokes ${name}'s access to the dashboard. You can reactivate them later.`
              : `This restores ${name}'s access to the dashboard.`}
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
            disabled={updateAdmin.isPending}
          >
            {action === 'deactivate' ? 'Deactivate' : 'Reactivate'}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}

function ResetPasswordDialog({
  open,
  onOpenChange,
  admin,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  admin: Admin
}) {
  const { setTempPasswordResult } = useAdmins()
  const resetPassword = useResetAdminPasswordMutation()

  const handleConfirm = () => {
    resetPassword.mutate(admin.id, {
      onSuccess: (result) => {
        setTempPasswordResult({
          email: admin.email,
          temporaryPassword: result.temporaryPassword,
        })
        onOpenChange(false)
      },
      onError: (error) => {
        toast.error('Could not reset password', {
          description: errorMessage(error, 'Please try again.'),
        })
      },
    })
  }

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Reset password for {admin.email}?</AlertDialogTitle>
          <AlertDialogDescription>
            This immediately invalidates their current password and issues a new
            one-time temporary password for you to hand off.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancel</AlertDialogCancel>
          <AlertDialogAction
            onClick={handleConfirm}
            disabled={resetPassword.isPending}
          >
            Reset password
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
