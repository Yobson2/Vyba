import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { useEditorialListQuery } from './api/editorial-api'
import { columns } from './components/editorial-columns'
import { EditorialDialogs } from './components/editorial-dialogs'
import { EditorialPrimaryButtons } from './components/editorial-primary-buttons'
import { EditorialTable } from './components/editorial-table'
import EditorialProvider from './context/editorial-context'

export default function Editorial() {
  const { data: items, isLoading, isError, error } = useEditorialListQuery()

  return (
    <EditorialProvider>
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
              Editorial composer
            </h2>
            <p className='text-muted-foreground'>
              Team-authored feed content — keeps the feed alive on quiet nights.
            </p>
          </div>
          <EditorialPrimaryButtons />
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          {isError ? (
            <p className='text-destructive py-8 text-center'>
              Failed to load editorial items
              {error instanceof Error ? `: ${error.message}` : '.'}
            </p>
          ) : isLoading ? (
            <p className='text-muted-foreground py-8 text-center'>
              Loading editorial items...
            </p>
          ) : (
            <EditorialTable data={items ?? []} columns={columns} />
          )}
        </div>
      </Main>

      <EditorialDialogs />
    </EditorialProvider>
  )
}
