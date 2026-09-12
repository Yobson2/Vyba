import type { VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'
import { Badge, type badgeVariants } from '@/components/ui/badge'

export type StatusType =
  | 'active'
  | 'pending'
  | 'inactive'
  | 'new'
  | 'completed'
  | 'cancelled'
  | 'approved'
  | 'rejected'
  | string

type BadgeVariant = NonNullable<VariantProps<typeof badgeVariants>['variant']>

interface StatusBadgeProps {
  status: StatusType
  className?: string
}

const statusVariantMap: Record<string, BadgeVariant> = {
  active: 'success',
  approved: 'success',
  new: 'default',
  pending: 'warning',
  processing: 'info',
  inactive: 'destructive',
  cancelled: 'destructive',
  rejected: 'destructive',
  completed: 'secondary',
}

export function StatusBadge({ status, className }: StatusBadgeProps) {
  const statusKey = status.toLowerCase()
  const variant = statusVariantMap[statusKey] || 'secondary'

  return (
    <Badge variant={variant} className={cn('capitalize', className)}>
      {status}
    </Badge>
  )
}
