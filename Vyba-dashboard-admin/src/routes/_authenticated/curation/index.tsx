import { createFileRoute } from '@tanstack/react-router'
import Curation from '@/features/curation'

export const Route = createFileRoute('/_authenticated/curation/')({
  component: Curation,
})
