import { createFileRoute } from '@tanstack/react-router'
import ComingSoon from '@/components/coming-soon'

// Placeholder — the editorial composer is built in a later validation MVP unit.
export const Route = createFileRoute('/_authenticated/editorial/')({
  component: ComingSoon,
})
