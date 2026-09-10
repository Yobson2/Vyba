import { createFileRoute } from '@tanstack/react-router'
import ComingSoon from '@/components/coming-soon'

// Placeholder — the photo curation queue is built in a later validation MVP unit.
export const Route = createFileRoute('/_authenticated/curation/')({
  component: ComingSoon,
})
