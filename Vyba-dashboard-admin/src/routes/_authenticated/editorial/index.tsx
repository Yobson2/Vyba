import { createFileRoute } from '@tanstack/react-router'
import Editorial from '@/features/editorial'

export const Route = createFileRoute('/_authenticated/editorial/')({
  component: Editorial,
})
