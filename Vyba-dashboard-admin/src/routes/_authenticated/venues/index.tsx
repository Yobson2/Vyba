import { createFileRoute } from '@tanstack/react-router'
import Venues from '@/features/venues'

export const Route = createFileRoute('/_authenticated/venues/')({
  component: Venues,
})
