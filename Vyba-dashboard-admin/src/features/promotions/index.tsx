import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { columns } from './components/promotions-columns'
import { PromotionsDialogs } from './components/promotions-dialogs'
import { PromotionsTable } from './components/promotions-table'
import PromotionsProvider from './context/promotions-context'
import { promotionListSchema } from './data/schema'
import { promotions } from './data/promotions'

export default function Promotions() {
  // Parse promotion list
  const promotionList = promotionListSchema.parse(promotions)

  return (
    <PromotionsProvider>
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
            <h2 className='text-2xl font-bold tracking-tight'>Promotions</h2>
            <p className='text-muted-foreground'>
              Manage venue promotions and featured content.
            </p>
          </div>
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          <PromotionsTable data={promotionList} columns={columns} />
        </div>
      </Main>

      <PromotionsDialogs />
    </PromotionsProvider>
  )
}
