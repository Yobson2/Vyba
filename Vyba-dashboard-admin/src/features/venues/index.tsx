import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { columns } from './components/venues-columns'
import { VenuesDialogs } from './components/venues-dialogs'
import { VenuesPrimaryButtons } from './components/venues-primary-buttons'
import { VenuesTable } from './components/venues-table'
import VenuesProvider from './context/venues-context'
import { venueListSchema } from './data/schema'
import { venues } from './data/venues'

export default function Venues() {
  // Parse venue list
  const venueList = venueListSchema.parse(venues)

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
            <h2 className='text-2xl font-bold tracking-tight'>Venues</h2>
            <p className='text-muted-foreground'>
              Manage venues, approvals, and listings.
            </p>
          </div>
          <VenuesPrimaryButtons />
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          <VenuesTable data={venueList} columns={columns} />
        </div>
      </Main>

      <VenuesDialogs />
    </VenuesProvider>
  )
}
