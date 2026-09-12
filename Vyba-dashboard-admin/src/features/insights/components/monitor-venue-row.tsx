import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { MonitorVenue } from '../data/schema'

function feedItemLabel(item: MonitorVenue['recentFeedItems'][number]): string {
  const title = item.payload?.title
  if (typeof title === 'string' && title.length > 0) return title
  return item.type
}

export function MonitorVenueRow({ venue }: { venue: MonitorVenue }) {
  return (
    <div
      className={
        'bg-card flex flex-col gap-3 rounded-md p-4 sm:flex-row sm:items-center sm:justify-between' +
        (venue.quiet ? ' ring-warning/40 ring-1' : '')
      }
    >
      <div className='flex flex-1 flex-col gap-1'>
        <div className='flex flex-wrap items-center gap-2'>
          <span className='font-medium'>{venue.venueName}</span>
          {venue.quiet && (
            <Badge variant='warning'>Silencieux — à relancer</Badge>
          )}
          {venue.isLive && <Badge variant='success'>Live</Badge>}
        </div>
        <div className='text-muted-foreground flex flex-wrap gap-1 gap-x-4 text-sm'>
          <span>{venue.goingCount} y vont</span>
          <span>{venue.postCountToday} publication(s) aujourd'hui</span>
          {venue.isLive && venue.liveSince && (
            <span>
              Live depuis {new Date(venue.liveSince).toLocaleTimeString()}
            </span>
          )}
        </div>
        {venue.recentFeedItems.length > 0 && (
          <p className='text-muted-foreground text-xs'>
            Récent : {venue.recentFeedItems.map(feedItemLabel).join(' · ')}
          </p>
        )}
      </div>
      <div className='flex shrink-0 gap-2'>
        <Button variant='outline' size='sm' asChild>
          <a href='/venues'>Provisioning</a>
        </Button>
        <Button variant='outline' size='sm' asChild>
          <a href='/promotions'>Contenu</a>
        </Button>
      </div>
    </div>
  )
}
