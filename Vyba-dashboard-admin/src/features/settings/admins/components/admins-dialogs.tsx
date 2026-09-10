import { useState } from 'react'
import { toast } from 'sonner'
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
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
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
import { ADMIN_ROLES, ROLE_LABELS, type AdminRole } from '@/types/admin'
import { useAdmins } from '../context/admins-context'

export function AdminsDialogs() {
  const { open, setOpen, currentRow } = useAdmins()

  return (
    <>
      <InviteDialog
        open={open === 'invite'}
        onOpenChange={(v) => setOpen(v ? 'invite' : null)}
      />
      {currentRow && (
        <>
          <EditRoleDialog
            open={open === 'edit'}
            onOpenChange={(v) => setOpen(v ? 'edit' : null)}
            admin={currentRow}
          />
          <DeleteDialog
            open={open === 'delete'}
            onOpenChange={(v) => setOpen(v ? 'delete' : null)}
            admin={currentRow}
          />
        </>
      )}
    </>
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
  const [role, setRole] = useState<AdminRole>('ADMIN')

  const handleInvite = () => {
    if (!email.trim()) return
    toast.success(`Invitation sent to ${email}`)
    setEmail('')
    setRole('ADMIN')
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Invite Admin</DialogTitle>
          <DialogDescription>
            Send an invitation to join the Vyba admin dashboard.
          </DialogDescription>
        </DialogHeader>
        <div className='space-y-4 py-4'>
          <div className='space-y-2'>
            <Label htmlFor='invite-email'>Email address</Label>
            <Input
              id='invite-email'
              type='email'
              placeholder='admin@vyba.app'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div className='space-y-2'>
            <Label htmlFor='invite-role'>Role</Label>
            <Select
              value={role}
              onValueChange={(v) => setRole(v as AdminRole)}
            >
              <SelectTrigger id='invite-role'>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {ADMIN_ROLES.map((r) => (
                  <SelectItem key={r} value={r}>
                    {ROLE_LABELS[r]}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant='ghost' onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleInvite} disabled={!email.trim()}>
            Send invitation
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function EditRoleDialog({
  open,
  onOpenChange,
  admin,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  admin: { name: string; role: AdminRole }
}) {
  const [role, setRole] = useState<AdminRole>(admin.role)

  const handleSave = () => {
    toast.success(`${admin.name}'s role updated to ${ROLE_LABELS[role]}`)
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Edit Role</DialogTitle>
          <DialogDescription>
            Change the role for {admin.name}.
          </DialogDescription>
        </DialogHeader>
        <div className='space-y-2 py-4'>
          <Label>Role</Label>
          <Select
            value={role}
            onValueChange={(v) => setRole(v as AdminRole)}
          >
            <SelectTrigger>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {ADMIN_ROLES.map((r) => (
                <SelectItem key={r} value={r}>
                  {ROLE_LABELS[r]}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <DialogFooter>
          <Button variant='ghost' onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleSave}>Save changes</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function DeleteDialog({
  open,
  onOpenChange,
  admin,
}: {
  open: boolean
  onOpenChange: (open: boolean) => void
  admin: { name: string; status: string }
}) {
  const action = admin.status === 'active' ? 'deactivate' : 'remove'

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>
            {action === 'deactivate' ? 'Deactivate' : 'Remove'} {admin.name}?
          </AlertDialogTitle>
          <AlertDialogDescription>
            {action === 'deactivate'
              ? `This will revoke ${admin.name}'s access to the dashboard. You can reactivate them later.`
              : `This will permanently remove ${admin.name} from the admin team. This action cannot be undone.`}
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancel</AlertDialogCancel>
          <AlertDialogAction
            className='bg-destructive text-destructive-foreground hover:bg-destructive/90'
            onClick={() => {
              toast.success(
                action === 'deactivate'
                  ? `${admin.name} has been deactivated.`
                  : `${admin.name} has been removed.`
              )
            }}
          >
            {action === 'deactivate' ? 'Deactivate' : 'Remove'}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
