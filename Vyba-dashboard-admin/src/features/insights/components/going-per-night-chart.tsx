import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { DEFINITIONS } from '../data/definitions'
import { GoingPerNight } from '../data/schema'

function isWeekendNight(dateISO: string): boolean {
  const day = new Date(`${dateISO}T00:00:00Z`).getUTCDay()
  return day === 5 || day === 6 // Friday, Saturday
}

/** Going activity per night, last ~8 weeks, weekend nights highlighted (spec 18). */
export function GoingPerNightChart({ series }: { series: GoingPerNight }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>"J'y vais" par nuit</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width='100%' height={260}>
          <BarChart data={series}>
            <CartesianGrid strokeDasharray='3 3' className='stroke-muted' />
            <XAxis
              dataKey='date'
              className='text-xs'
              tick={{ fill: 'currentColor' }}
            />
            <YAxis className='text-xs' tick={{ fill: 'currentColor' }} />
            <Tooltip
              contentStyle={{
                backgroundColor: 'hsl(var(--popover))',
                border: 'none',
                borderRadius: '8px',
                color: 'hsl(var(--popover-foreground))',
              }}
            />
            <Bar dataKey='total' radius={[4, 4, 0, 0]}>
              {series.map((row) => (
                <Cell
                  key={row.date}
                  fill={isWeekendNight(row.date) ? '#B0A3FF' : '#69F6B8'}
                  fillOpacity={0.8}
                />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
        <p className='text-muted-foreground mt-2 text-xs'>
          {DEFINITIONS.goingPerNight} Violet = vendredi/samedi.
        </p>
      </CardContent>
    </Card>
  )
}
