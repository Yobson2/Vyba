import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { DEFINITIONS, GATE_TARGETS } from '../data/definitions'
import { RetentionReport, RetentionWindows } from '../data/schema'

function formatRate(rate: number | null): string {
  if (rate === null) return 'N/A'
  return `${Math.round(rate * 100)}%`
}

function RetentionRow({
  label,
  windows,
}: {
  label: string
  windows: RetentionWindows
}) {
  return (
    <div className='flex flex-wrap items-center justify-between gap-2 py-2'>
      <span className='text-sm font-medium'>{label}</span>
      <div className='flex gap-4 text-sm'>
        <span>S1 : {formatRate(windows.week1.rate)}</span>
        <span>S2 : {formatRate(windows.week2.rate)}</span>
        <span className='font-semibold'>
          S4 : {formatRate(windows.week4.rate)} /{' '}
          {GATE_TARGETS.weekFourRetention}
        </span>
      </div>
    </div>
  )
}

/** Week-1/2/4 retention, overall and by acquisition source (spec 18/23). */
export function RetentionPanel({ report }: { report: RetentionReport }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Rétention</CardTitle>
      </CardHeader>
      <CardContent>
        <RetentionRow label='Ensemble' windows={report.overall} />
        {Object.entries(report.bySource).length > 0 && (
          <div className='bg-muted/50 mt-2 rounded-md px-3 py-1'>
            {Object.entries(report.bySource).map(([source, windows]) => (
              <RetentionRow key={source} label={source} windows={windows} />
            ))}
          </div>
        )}
        <p className='text-muted-foreground mt-2 text-xs'>
          {DEFINITIONS.retention}
        </p>
      </CardContent>
    </Card>
  )
}
