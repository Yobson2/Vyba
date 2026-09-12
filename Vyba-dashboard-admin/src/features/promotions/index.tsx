import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { AssistForm } from './components/assist-form'

export default function Promotions() {
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
        <div className='mb-2'>
          <h2 className='text-2xl font-bold tracking-tight'>Assist mode</h2>
          <p className='text-muted-foreground'>
            Post on behalf of a venue that hasn&apos;t posted yet — the backend
            always records it as founder-assisted.
          </p>
        </div>
        <AssistForm />
      </Main>
    </>
  )
}
