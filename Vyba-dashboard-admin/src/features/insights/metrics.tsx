import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import {
  useActiveVenuesQuery,
  useContentActivityQuery,
  useGoingPerNightQuery,
  useOrganicPostingQuery,
  useRetentionQuery,
  useZone4WauQuery,
} from './api/metrics-api'
import { GoingPerNightChart } from './components/going-per-night-chart'
import { MetricCard } from './components/metric-card'
import { PostHogLinksPanel } from './components/posthog-links-panel'
import { RetentionPanel } from './components/retention-panel'
import { DEFINITIONS, GATE_TARGETS } from './data/definitions'

/** The page body, kept separate from the `Header`/sidebar chrome so it's testable without a `SidebarProvider` (mirrors the `curation`/`editorial` features' test seam). */
export function MetricsContent() {
  const wauQuery = useZone4WauQuery()
  const retentionQuery = useRetentionQuery()
  const organicPostingQuery = useOrganicPostingQuery()
  const goingPerNightQuery = useGoingPerNightQuery()
  const activeVenuesQuery = useActiveVenuesQuery()
  const contentActivityQuery = useContentActivityQuery()

  return (
    <>
      <div className='mb-2'>
        <h2 className='text-2xl font-bold tracking-tight'>
          Validation metrics
        </h2>
        <p className='text-muted-foreground'>
          Les indicateurs de la §23 — pour la revue mensuelle, pas une promesse
          de traction.
        </p>
      </div>

      <div className='grid gap-4 sm:grid-cols-2 lg:grid-cols-3'>
        <MetricCard
          title='Zone 4 WAU'
          value={
            wauQuery.isLoading
              ? '...'
              : `${wauQuery.data ?? 0} / ${GATE_TARGETS.zone4Wau}`
          }
          definition={DEFINITIONS.zone4Wau}
        />
        <MetricCard
          title='Rétention semaine 4'
          value={
            retentionQuery.isLoading
              ? '...'
              : retentionQuery.data?.overall.week4.rate !== null &&
                  retentionQuery.data?.overall.week4.rate !== undefined
                ? `${Math.round(retentionQuery.data.overall.week4.rate * 100)}% / ${GATE_TARGETS.weekFourRetention}`
                : `N/A / ${GATE_TARGETS.weekFourRetention}`
          }
          definition={DEFINITIONS.retention}
        />
        <MetricCard
          title='Publication organique'
          value={
            organicPostingQuery.isLoading
              ? '...'
              : `${organicPostingQuery.data?.organicVenueCount ?? 0} / ~${organicPostingQuery.data?.totalVenueCount ?? 0} (${GATE_TARGETS.organicPosting})`
          }
          definition={DEFINITIONS.organicPosting}
        />
        <MetricCard
          title='Lieux actifs'
          value={
            activeVenuesQuery.isLoading ? '...' : (activeVenuesQuery.data ?? 0)
          }
          definition='Lieux approuvés, validés et actifs sur le marché de lancement.'
        />
        <MetricCard
          title='Activité de contenu (semaine)'
          value={
            contentActivityQuery.isLoading
              ? '...'
              : Object.values(contentActivityQuery.data ?? {}).reduce(
                  (sum, n) => sum + n,
                  0
                )
          }
          definition='Éléments du fil publiés cette semaine, tous types confondus.'
        />
      </div>

      <div className='mt-4 grid gap-4 lg:grid-cols-2'>
        {retentionQuery.data && <RetentionPanel report={retentionQuery.data} />}
        <PostHogLinksPanel />
      </div>

      {goingPerNightQuery.data && (
        <div className='mt-4'>
          <GoingPerNightChart series={goingPerNightQuery.data} />
        </div>
      )}
    </>
  )
}

export default function Metrics() {
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
        <MetricsContent />
      </Main>
    </>
  )
}
