import { useState } from 'react'
import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { SelectDropdown } from '@/components/select-dropdown'
import { ThemeSwitch } from '@/components/theme-switch'
import { useCurationQueueQuery } from './api/curation-api'
import { columns } from './components/curation-columns'
import { CurationDialogs } from './components/curation-dialogs'
import { CurationTable } from './components/curation-table'
import CurationProvider from './context/curation-context'
import { MediaAssetStatus } from './data/schema'

const STATUS_OPTIONS: { label: string; value: MediaAssetStatus | 'all' }[] = [
  { label: 'Needs review (active)', value: 'active' },
  { label: 'Hidden', value: 'hidden' },
  { label: 'Deleted', value: 'deleted' },
  { label: 'All', value: 'all' },
]

export default function Curation() {
  const [status, setStatus] = useState<MediaAssetStatus | 'all'>('active')
  const {
    data: items,
    isLoading,
    isError,
    error,
  } = useCurationQueueQuery(status === 'all' ? {} : { status })

  return (
    <CurationProvider>
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
              Photo curation
            </h2>
            <p className='text-muted-foreground'>
              User-submitted night photos — promote a good one into the main
              feed, or hide/delete it.
            </p>
          </div>
          <SelectDropdown
            className='w-56'
            isControlled
            defaultValue={status}
            onValueChange={(value) =>
              setStatus(value as MediaAssetStatus | 'all')
            }
            items={STATUS_OPTIONS}
          />
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          {isError ? (
            <p className='text-destructive py-8 text-center'>
              Failed to load the curation queue
              {error instanceof Error ? `: ${error.message}` : '.'}
            </p>
          ) : isLoading ? (
            <p className='text-muted-foreground py-8 text-center'>
              Loading photos...
            </p>
          ) : (
            <CurationTable data={items ?? []} columns={columns} />
          )}
        </div>
      </Main>

      <CurationDialogs />
    </CurationProvider>
  )
}
