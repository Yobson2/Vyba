import { IconBuildingPlus } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import { useVenues } from '../context/venues-context'

export function VenuesPrimaryButtons() {
  const { setOpen } = useVenues()
  return (
    <div className='flex gap-2'>
      <Button className='space-x-1' onClick={() => setOpen('add')}>
        <span>Add Venue</span> <IconBuildingPlus size={18} />
      </Button>
    </div>
  )
}
