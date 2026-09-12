import { createFileRoute } from '@tanstack/react-router'
import Metrics from '@/features/insights/metrics'

export const Route = createFileRoute('/_authenticated/analytics/')({
  component: Metrics,
})
