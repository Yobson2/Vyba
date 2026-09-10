import { IconDotsVertical } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import type { Admin } from '../data/schema'
import { useAdmins } from '../context/admins-context'

export function AdminRowActions({ admin }: { admin: Admin }) {
  const { setOpen, setCurrentRow } = useAdmins()

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
          Edit role
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          className='text-destructive'
          onClick={() => {
            setCurrentRow(admin)
            setOpen('delete')
          }}
        >
          {admin.status === 'active' ? 'Deactivate' : 'Remove'}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
