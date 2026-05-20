import { IconDeviceDesktop } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip'
import { SettingsCard } from '../components/settings-card'

export function SessionsCard() {
  return (
    <SettingsCard
      title='Active Sessions'
      description='Manage devices where you are currently signed in.'
    >
      <div className='space-y-4'>
        <div className='flex items-center justify-between'>
          <div className='flex items-center gap-3'>
            <div className='bg-primary/10 flex h-10 w-10 items-center justify-center rounded-lg'>
              <IconDeviceDesktop size={20} className='text-primary' />
            </div>
            <div>
              <p className='text-sm font-medium'>Current session</p>
              <p className='text-muted-foreground text-xs'>
                This browser &middot; Active now
              </p>
            </div>
          </div>
          <span className='bg-secondary/20 text-secondary-foreground rounded-full px-2 py-0.5 text-xs font-medium'>
            Current
          </span>
        </div>
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger asChild>
              <span>
                <Button variant='outline' size='sm' disabled>
                  Sign out all other sessions
                </Button>
              </span>
            </TooltipTrigger>
            <TooltipContent>
              <p>Coming soon</p>
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>
      </div>
    </SettingsCard>
  )
}
