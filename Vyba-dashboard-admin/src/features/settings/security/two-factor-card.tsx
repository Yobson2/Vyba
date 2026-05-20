import { IconShieldOff } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip'
import { SettingsCard } from '../components/settings-card'

export function TwoFactorCard() {
  return (
    <SettingsCard
      title='Two-Factor Authentication'
      description='Add an extra layer of security using an authenticator app.'
    >
      <div className='flex items-center justify-between'>
        <div className='flex items-center gap-3'>
          <div className='bg-muted/50 flex h-10 w-10 items-center justify-center rounded-lg'>
            <IconShieldOff size={20} className='text-muted-foreground' />
          </div>
          <div>
            <p className='text-sm font-medium'>Not enabled</p>
            <p className='text-muted-foreground text-xs'>
              Your account is not protected with 2FA.
            </p>
          </div>
        </div>
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger asChild>
              <span>
                <Button variant='outline' size='sm' disabled>
                  Enable 2FA
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
