import { IconRefresh } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { useTonightMonitorQuery } from './api/monitor-api'
import { MonitorVenueRow } from './components/monitor-venue-row'

/** The page body, kept separate from the `Header`/sidebar chrome so it's testable without a `SidebarProvider` (mirrors the `curation`/`editorial` features' test seam). */
export function MonitorContent() {
  const {
    data: venues,
    isLoading,
    isError,
    error,
    refetch,
    isFetching,
  } = useTonightMonitorQuery()

  // Quiet venues first — they're the action list (spec 18).
  const sorted = [...(venues ?? [])].sort(
    (a, b) => Number(b.quiet) - Number(a.quiet)
  )

  return (
    <>
      <div className='mb-2 flex flex-wrap items-center justify-between gap-2'>
        <div>
          <h2 className='text-2xl font-bold tracking-tight'>
            VenueNight monitor
          </h2>
          <p className='text-muted-foreground'>
            Ce soir, tous lieux confondus — les lieux silencieux remontent en
            premier.
          </p>
        </div>
        <Button
          variant='outline'
          size='sm'
          onClick={() => void refetch()}
          disabled={isFetching}
        >
          <IconRefresh className={isFetching ? 'animate-spin' : undefined} />
          Actualiser
        </Button>
      </div>

      <div className='flex flex-col gap-3'>
        {isError ? (
          <p className='text-destructive py-8 text-center'>
            Impossible de charger le monitor
            {error instanceof Error ? `: ${error.message}` : '.'}
          </p>
        ) : isLoading ? (
          <p className='text-muted-foreground py-8 text-center'>
            Chargement...
          </p>
        ) : sorted.length === 0 ? (
          <p className='text-muted-foreground py-8 text-center'>
            Aucun lieu actif.
          </p>
        ) : (
          sorted.map((venue) => (
            <MonitorVenueRow key={venue.venueId} venue={venue} />
          ))
        )}
      </div>
    </>
  )
}

export default function Monitor() {
  return (
    <>
      <Header fixed>
        <Search />
        <div className='ml-auto flex items-center space-x-4'>
          <ThemeSwitch />
          <ProfileDropdown />
        </div>
      </Header>

      <Main>
        <MonitorContent />
      </Main>
    </>
  )
}
