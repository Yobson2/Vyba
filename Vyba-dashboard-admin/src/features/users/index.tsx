import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { useUsersQuery } from './api/users-api'
import { columns } from './components/users-columns'
import { UsersDialogs } from './components/users-dialogs'
import { UsersTable } from './components/users-table'
import UsersProvider from './context/users-context'

export default function Users() {
  const { data: userList, isLoading, isError, error } = useUsersQuery()

  return (
    <UsersProvider>
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
            <h2 className='text-2xl font-bold tracking-tight'>Users</h2>
            <p className='text-muted-foreground'>
              Clients and venue owners — acquisition source for support
              lookup, deactivate/reactivate access.
            </p>
          </div>
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          {isError ? (
            <p className='text-destructive py-8 text-center'>
              Failed to load users
              {error instanceof Error ? `: ${error.message}` : '.'}
            </p>
          ) : isLoading ? (
            <p className='text-muted-foreground py-8 text-center'>
              Loading users...
            </p>
          ) : (
            <UsersTable data={userList ?? []} columns={columns} />
          )}
        </div>
      </Main>

      <UsersDialogs />
    </UsersProvider>
  )
}
