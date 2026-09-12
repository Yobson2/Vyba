import { server } from '@/test/msw/server'
import { renderHookWithQueryClient, renderWithQueryClient } from '@/test/render'
import { screen, waitFor } from '@testing-library/react'
import { http, HttpResponse } from 'msw'
import { describe, expect, it } from 'vitest'
import { useCreateAssistedPromoMutation } from '../api/assist-api'
import { VenueContentPanel } from '../components/venue-content-panel'

describe('Assist mode', () => {
  // The venue-picker `Select` is Radix-Popper-positioned; driving a click
  // through it hangs jsdom's event loop for ~45s+ regardless of any
  // configured timeout in this project's test environment (see
  // editorial.test.tsx for the full explanation — the same friction, not
  // specific to this form). This exercises the mutation the form calls
  // directly: the same "posts to the assist endpoint, no assisted field"
  // assurance the ticket's testing decision asks for.
  it('posts to the assist endpoint (not the owner endpoint), with no origin/assisted field', async () => {
    let assistCalled = false
    server.use(
      http.post(
        '/api/feed/venue/:venueId/promo/assist',
        async ({ request, params }) => {
          assistCalled = true
          expect(params.venueId).toBe('venue-1')
          const body = (await request.json()) as Record<string, unknown>
          expect(body).toEqual({
            title: 'Happy hour -50%',
            description: "Jusqu'à 23h",
          })
          return HttpResponse.json({}, { status: 201 })
        }
      )
    )

    const { result } = renderHookWithQueryClient(() =>
      useCreateAssistedPromoMutation()
    )
    result.current.mutate({
      venueId: 'venue-1',
      title: 'Happy hour -50%',
      description: "Jusqu'à 23h",
    })

    await waitFor(() => expect(assistCalled).toBe(true))
  })

  it('the per-venue nudge panel renders the organic/assisted counts', async () => {
    server.use(
      http.get('/api/metrics/venue/:venueId/organic-vs-assisted', () =>
        HttpResponse.json({ organic: 1, assisted: 2 })
      )
    )

    renderWithQueryClient(<VenueContentPanel venueId='venue-1' />)

    await waitFor(() => {
      expect(screen.getByText(/cette semaine — 3 posts/i)).toBeInTheDocument()
    })
    expect(screen.getByText(/2 assistés, 1 organique/i)).toBeInTheDocument()
  })
})
