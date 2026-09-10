import { createFileRoute, redirect } from '@tanstack/react-router'

// The dashboard is a team-only tool with no public landing page.
// Send the root path to the operator home (which enforces auth).
export const Route = createFileRoute('/')({
  beforeLoad: () => {
    throw redirect({ to: '/dashboard' })
  },
})
