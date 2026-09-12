import { server } from '@/test/msw/server'
import { renderHookWithQueryClient, renderWithQueryClient } from '@/test/render'
import { screen, waitFor } from '@testing-library/react'
import { http, HttpResponse } from 'msw'
import { describe, expect, it } from 'vitest'
import {
  useDeletePhotoMutation,
  useHidePhotoMutation,
  usePromotePhotoMutation,
} from '../api/curation-api'
import { columns } from '../components/curation-columns'
import { CurationTable } from '../components/curation-table'
import CurationProvider from '../context/curation-context'
import { CurationQueueItem } from '../data/schema'

const queueItem: CurationQueueItem = {
  id: 'photo-1',
  url: 'https://cdn.example/photo.jpg',
  thumbnailUrl: 'https://cdn.example/photo-thumb.jpg',
  venueId: 'venue-1',
  venueNightId: 'night-1',
  venueNightDate: '2026-03-05',
  uploadedByUserId: 'user-abcdef12',
  status: 'active',
  feedPromoted: false,
  createdAt: new Date(),
}

describe('Photo curation queue', () => {
  it('lists a photo with its resolved venue name and night date', async () => {
    server.use(
      http.get('/api/media/admin', () => HttpResponse.json([queueItem])),
      http.get('/api/venues', () =>
        HttpResponse.json({
          data: [
            {
              id: 'venue-1',
              name: 'Le Sunset Club',
              description: null,
              address: null,
              latitude: 5.285,
              longitude: -3.985,
              venueType: 'LOUNGE',
              priceLevel: 2,
              ownerUserId: null,
              owner: null,
              validationStatus: 'ACTIVE',
              inLaunchArea: true,
              isActive: true,
              createdAt: new Date().toISOString(),
              updatedAt: new Date().toISOString(),
            },
          ],
          meta: { page: 1, limit: 100, total: 1, totalPages: 1 },
        })
      )
    )

    renderWithQueryClient(
      <CurationProvider>
        <CurationTable data={[queueItem]} columns={columns} />
      </CurationProvider>
    )

    await waitFor(() => {
      expect(screen.getByText('Le Sunset Club')).toBeInTheDocument()
    })
    expect(screen.getByText('2026-03-05')).toBeInTheDocument()
    expect(screen.getByText('Active')).toBeInTheDocument()
  })

  // The row actions live behind a Radix `DropdownMenu` (Popper-positioned) —
  // see editorial.test.tsx for why these exercise the mutation hooks the row
  // actions call directly, instead of driving the click-through in jsdom.
  it('the promote mutation calls the promote endpoint for the right photo', async () => {
    let promoteCalled = false
    server.use(
      http.patch('/api/media/:id/promote', ({ params }) => {
        promoteCalled = true
        expect(params.id).toBe('photo-1')
        return HttpResponse.json({ ...queueItem, feedPromoted: true })
      })
    )

    const { result } = renderHookWithQueryClient(() =>
      usePromotePhotoMutation()
    )
    result.current.mutate('photo-1')

    await waitFor(() => expect(promoteCalled).toBe(true))
  })

  it('the hide mutation calls the hide endpoint for the right photo', async () => {
    let hideCalled = false
    server.use(
      http.patch('/api/media/:id/hide', ({ params }) => {
        hideCalled = true
        expect(params.id).toBe('photo-1')
        return HttpResponse.json({ ...queueItem, status: 'hidden' })
      })
    )

    const { result } = renderHookWithQueryClient(() => useHidePhotoMutation())
    result.current.mutate('photo-1')

    await waitFor(() => expect(hideCalled).toBe(true))
  })

  it('the delete mutation calls the admin hard-delete endpoint for the right photo', async () => {
    let deleteCalled = false
    server.use(
      http.delete('/api/media/admin/:id', ({ params }) => {
        deleteCalled = true
        expect(params.id).toBe('photo-1')
        return HttpResponse.json({})
      })
    )

    const { result } = renderHookWithQueryClient(() => useDeletePhotoMutation())
    result.current.mutate('photo-1')

    await waitFor(() => expect(deleteCalled).toBe(true))
  })
})
