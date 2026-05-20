import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { columns } from './components/reviews-columns'
import { ReviewsDialogs } from './components/reviews-dialogs'
import { ReviewsTable } from './components/reviews-table'
import ReviewsProvider from './context/reviews-context'
import { reviewListSchema } from './data/schema'
import { reviews } from './data/reviews'

export default function Reviews() {
  // Parse review list
  const reviewList = reviewListSchema.parse(reviews)

  return (
    <ReviewsProvider>
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
              Reviews & Moderation
            </h2>
            <p className='text-muted-foreground'>
              Moderate user reviews and flagged content.
            </p>
          </div>
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          <ReviewsTable data={reviewList} columns={columns} />
        </div>
      </Main>

      <ReviewsDialogs />
    </ReviewsProvider>
  )
}
