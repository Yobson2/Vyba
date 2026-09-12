import { IconPencilPlus } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import { useEditorial } from '../context/editorial-context'

export function EditorialPrimaryButtons() {
  const { setOpen } = useEditorial()
  return (
    <div className='flex gap-2'>
      <Button className='space-x-1' onClick={() => setOpen('add')}>
        <span>New editorial item</span> <IconPencilPlus size={18} />
      </Button>
    </div>
  )
}
