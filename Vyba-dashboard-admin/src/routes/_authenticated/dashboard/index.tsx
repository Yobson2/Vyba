import { createFileRoute } from '@tanstack/react-router'
import Monitor from '@/features/insights/monitor'

export const Route = createFileRoute('/_authenticated/dashboard/')({
  component: Monitor,
})
