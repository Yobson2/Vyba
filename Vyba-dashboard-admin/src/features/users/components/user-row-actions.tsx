import { IconDotsVertical } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useUsers } from '../context/users-context'
import type { User } from '../data/schema'

export function UserRowActions({ user }: { user: User }) {
  const { setOpen, setCurrentRow } = useUsers()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant='ghost' size='icon' className='h-8 w-8'>
          <IconDotsVertical size={16} />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align='end'>
        <DropdownMenuItem
          className={user.isActive ? 'text-destructive' : undefined}
          onClick={() => {
            setCurrentRow(user)
            setOpen('deactivate')
          }}
        >
          {user.isActive ? 'Deactivate' : 'Reactivate'}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
