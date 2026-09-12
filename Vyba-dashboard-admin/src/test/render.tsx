import type { ReactElement, ReactNode } from 'react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render, renderHook } from '@testing-library/react'

function newTestQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  })
}

/** A fresh, no-retry `QueryClient` per test — this project's page-level test seam (ticket 13). */
export function renderWithQueryClient(ui: ReactElement) {
  const queryClient = newTestQueryClient()
  return {
    queryClient,
    ...render(
      <QueryClientProvider client={queryClient}>{ui}</QueryClientProvider>
    ),
  }
}

/**
 * Same, for testing a TanStack Query hook (a mutation's endpoint/payload)
 * directly — the pragmatic seam for interactions that would otherwise have
 * to click through a Radix `DropdownMenu`/`Select` (see editorial.test.tsx).
 */
export function renderHookWithQueryClient<T>(hook: () => T) {
  const queryClient = newTestQueryClient()
  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )
  return { queryClient, ...renderHook(hook, { wrapper }) }
}
