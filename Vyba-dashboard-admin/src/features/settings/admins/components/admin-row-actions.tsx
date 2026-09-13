import { IconDotsVertical } from '@tabler/icons-react'
import { useAuthStore } from '@/stores/authStore'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useAdmins } from '../context/admins-context'
import type { Admin } from '../data/schema'

export function AdminRowActions({ admin }: { admin: Admin }) {
  const { setOpen, setCurrentRow } = useAdmins()
  const currentUserId = useAuthStore((s) => s.auth.user?.accountNo)
  const isSelf = admin.id === currentUserId

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant='ghost' size='icon' className='h-8 w-8'>
          <IconDotsVertical size={16} />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align='end'>
        <DropdownMenuItem
          onClick={() => {
            setCurrentRow(admin)
            setOpen('edit')
          }}
        >
          Edit
        </DropdownMenuItem>
        <DropdownMenuItem
          onClick={() => {
            setCurrentRow(admin)
            setOpen('reset-password')
          }}
        >
          Reset password
        </DropdownMenuItem>
        {!isSelf && (
          <>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              className='text-destructive'
              onClick={() => {
                setCurrentRow(admin)
                setOpen('deactivate')
              }}
            >
              {admin.isActive ? 'Deactivate' : 'Reactivate'}
            </DropdownMenuItem>
          </>
        )}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
