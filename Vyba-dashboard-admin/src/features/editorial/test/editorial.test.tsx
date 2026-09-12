import { server } from '@/test/msw/server'
import { renderHookWithQueryClient, renderWithQueryClient } from '@/test/render'
import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import { beforeEach, describe, expect, it } from 'vitest'
import {
  useDeleteFeedItemMutation,
  useEditorialListQuery,
  useHideFeedItemMutation,
} from '../api/editorial-api'
import { columns } from '../components/editorial-columns'
import { EditorialDialogs } from '../components/editorial-dialogs'
import { EditorialPrimaryButtons } from '../components/editorial-primary-buttons'
import { EditorialTable } from '../components/editorial-table'
import EditorialProvider from '../context/editorial-context'

function EditorialTestPage() {
  const { data } = useEditorialListQuery()
  return (
    <EditorialProvider>
      <EditorialPrimaryButtons />
      <EditorialTable data={data ?? []} columns={columns} />
      <EditorialDialogs />
    </EditorialProvider>
  )
}

const publishedItem = {
  id: 'item-1',
  type: 'EDITORIAL',
  venueId: null,
  status: 'PUBLISHED',
  publishedAt: new Date().toISOString(),
  expiresAt: new Date(Date.now() + 86400000).toISOString(),
  payload: { title: 'Ce soir à Zone 4', body: '5 spots chauds ce soir.' },
  createdAt: new Date().toISOString(),
}

describe('Editorial composer', () => {
  beforeEach(() => {
    // `EditorialActionDialog` always fetches the venue list for its
    // "Association" picker, even while closed — every test needs this.
    server.use(
      http.get('/api/venues', () =>
        HttpResponse.json({
          data: [],
          meta: { page: 1, limit: 100, total: 0, totalPages: 0 },
        })
      )
    )
  })

  it('submitting the compose form posts the right payload and the new item appears in the list', async () => {
    // Stateful fixture: the GET after invalidation must reflect the POST,
    // matching the real backend's behaviour (not just asserting the POST body).
    let items: Array<Record<string, unknown>> = []
    server.use(
      http.get('/api/feed/admin', () => HttpResponse.json(items)),
      http.post('/api/feed/editorial', async ({ request }) => {
        const body = (await request.json()) as Record<string, unknown>
        expect(body).toMatchObject({
          title: 'Ce soir à Zone 4',
          body: '5 spots chauds ce soir.',
        })
        // The form must never send origin/assisted — backend-derived only.
        expect(body).not.toHaveProperty('origin')
        expect(body).not.toHaveProperty('assisted')
        const created = { ...publishedItem, payload: body }
        items = [...items, created]
        return HttpResponse.json(created, { status: 201 })
      })
    )

    renderWithQueryClient(<EditorialTestPage />)
    const user = userEvent.setup({ pointerEventsCheck: 0 })

    await user.click(
      screen.getByRole('button', { name: /new editorial item/i })
    )
    const dialog = await screen.findByRole('dialog')

    await user.type(within(dialog).getByLabelText(/title/i), 'Ce soir à Zone 4')
    await user.type(
      within(dialog).getByLabelText(/body/i),
      '5 spots chauds ce soir.'
    )
    await user.click(
      within(dialog).getByRole('button', { name: /create item/i })
    )

    await waitFor(() => {
      expect(screen.getByText('Ce soir à Zone 4')).toBeInTheDocument()
    })
  })

  it('a scheduled item (future publishedAt) is listed as "Scheduled"', async () => {
    const scheduled = {
      ...publishedItem,
      id: 'item-scheduled',
      publishedAt: new Date(Date.now() + 86400000).toISOString(),
      payload: { title: 'Scheduled Item', body: 'x' },
    }
    server.use(
      http.get('/api/feed/admin', () => HttpResponse.json([scheduled]))
    )

    renderWithQueryClient(<EditorialTestPage />)

    await waitFor(() => {
      expect(screen.getByText('Scheduled Item')).toBeInTheDocument()
    })
    expect(screen.getByText('Scheduled')).toBeInTheDocument()
  })

  // The row actions live behind a Radix `DropdownMenu` (Popper-positioned).
  // In this project's jsdom test environment, driving a click through that
  // trigger hangs the event loop for ~45s+ regardless of any configured
  // timeout — a known category of friction between `@radix-ui/react-popper`'s
  // floating-ui positioning loop and jsdom's zeroed `getBoundingClientRect`
  // (not specific to this code: the pre-existing `venues` feature's row
  // actions use the exact same `DataTableRowActions` primitive and would hit
  // the same wall). These two exercise the mutation hooks the row actions
  // call directly instead — the same API-contract assurance the ticket's
  // testing decision asks for, without the fragile click-through.
  it('the hide mutation calls the hide endpoint for the right item', async () => {
    let hideCalled = false
    server.use(
      http.patch('/api/feed/:id/hide', ({ params }) => {
        hideCalled = true
        expect(params.id).toBe('item-1')
        return HttpResponse.json({ ...publishedItem, status: 'HIDDEN' })
      })
    )

    const { result } = renderHookWithQueryClient(() =>
      useHideFeedItemMutation()
    )
    result.current.mutate('item-1')

    await waitFor(() => expect(hideCalled).toBe(true))
  })

  it('the delete mutation calls the moderation delete endpoint for the right item', async () => {
    let deleteCalled = false
    server.use(
      http.delete('/api/feed/:id', ({ params }) => {
        deleteCalled = true
        expect(params.id).toBe('item-1')
        return HttpResponse.json({})
      })
    )

    const { result } = renderHookWithQueryClient(() =>
      useDeleteFeedItemMutation()
    )
    result.current.mutate('item-1')

    await waitFor(() => expect(deleteCalled).toBe(true))
  })
})
