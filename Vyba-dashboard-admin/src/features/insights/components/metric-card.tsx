import { ReactNode } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

interface MetricCardProps {
  title: string
  /** e.g. "312 / ~500" — value against the §23.3 gate target. */
  value: ReactNode
  definition: string
  children?: ReactNode
}

/** One gate metric: value vs target, its locked definition inline (spec 18). */
export function MetricCard({
  title,
  value,
  definition,
  children,
}: MetricCardProps) {
  return (
    <Card>
      <CardHeader className='pb-2'>
        <CardTitle className='text-sm font-medium'>{title}</CardTitle>
      </CardHeader>
      <CardContent>
        <div className='text-2xl font-bold'>{value}</div>
        <p className='text-muted-foreground mt-1 text-xs'>{definition}</p>
        {children}
      </CardContent>
    </Card>
  )
}
