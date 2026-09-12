import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { columns } from './components/bookings-columns'
import { BookingsDialogs } from './components/bookings-dialogs'
import { BookingsTable } from './components/bookings-table'
import BookingsProvider from './context/bookings-context'
import { bookings } from './data/bookings'
import { bookingListSchema } from './data/schema'

export default function Bookings() {
  // Parse booking list
  const bookingList = bookingListSchema.parse(bookings)

  return (
    <BookingsProvider>
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
            <h2 className='text-2xl font-bold tracking-tight'>Bookings</h2>
            <p className='text-muted-foreground'>
              Manage booking requests and confirmations.
            </p>
          </div>
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          <BookingsTable data={bookingList} columns={columns} />
        </div>
      </Main>

      <BookingsDialogs />
    </BookingsProvider>
  )
}
