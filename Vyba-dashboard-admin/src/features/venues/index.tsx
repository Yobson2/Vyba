import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { useVenuesQuery } from './api/venues-api'
import { columns } from './components/venues-columns'
import { VenuesDialogs } from './components/venues-dialogs'
import { VenuesPrimaryButtons } from './components/venues-primary-buttons'
import { VenuesTable } from './components/venues-table'
import VenuesProvider from './context/venues-context'

export default function Venues() {
  const { data: venueList, isLoading, isError, error } = useVenuesQuery()

  return (
    <VenuesProvider>
      <Header fixed>
        <Search />
        <div className='ml-auto flex items-center space-x-4'>
          <ThemeSwitch />
          <ProfileDropdown />
        </div>
      </Header>

      <Main>
        <div className='mb-2 flex flex-wrap items-center justify-between space-y-2'>
          <div>
            <h2 className='text-2xl font-bold tracking-tight'>
              Venues &amp; owners
            </h2>
            <p className='text-muted-foreground'>
              Create venues, provision owner accounts, and manage validation
              status — discovery isn't limited to Zone 4 (ADR-0005).
            </p>
          </div>
          <VenuesPrimaryButtons />
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          {isError ? (
            <p className='text-destructive py-8 text-center'>
              Failed to load venues
              {error instanceof Error ? `: ${error.message}` : '.'}
            </p>
          ) : isLoading ? (
            <p className='text-muted-foreground py-8 text-center'>
              Loading venues...
            </p>
          ) : (
            <VenuesTable data={venueList ?? []} columns={columns} />
          )}
        </div>
      </Main>

      <VenuesDialogs />
    </VenuesProvider>
  )
}
