import { server } from '@/test/msw/server'
import { renderWithQueryClient } from '@/test/render'
import { screen, waitFor } from '@testing-library/react'
import { http, HttpResponse } from 'msw'
import { describe, expect, it } from 'vitest'
import { MonitorContent } from '../monitor'

describe('VenueNight monitor', () => {
  it('shows a live venue with its liveSince and flags a quiet one, sorted to the top', async () => {
    server.use(
      http.get('/api/metrics/monitor/tonight', () =>
        HttpResponse.json([
          {
            venueId: 'venue-live',
            venueName: 'Le Boony',
            venueType: 'BAR',
            isLive: true,
            liveSince: new Date().toISOString(),
            goingCount: 20,
            postCountToday: 1,
            recentFeedItems: [],
            quiet: false,
          },
          {
            venueId: 'venue-quiet',
            venueName: 'Le Calme',
            venueType: 'LOUNGE',
            isLive: false,
            liveSince: null,
            goingCount: 1,
            postCountToday: 0,
            recentFeedItems: [],
            quiet: true,
          },
        ])
      )
    )

    renderWithQueryClient(<MonitorContent />)

    await waitFor(() => {
      expect(screen.getByText('Le Boony')).toBeInTheDocument()
    })
    expect(screen.getByText('Live')).toBeInTheDocument()
    expect(screen.getByText('20 y vont')).toBeInTheDocument()

    expect(screen.getByText('Silencieux — à relancer')).toBeInTheDocument()

    // Quiet venues sort to the top (spec 18).
    const names = screen
      .getAllByText(/Le Boony|Le Calme/)
      .map((el) => el.textContent)
    expect(names[0]).toBe('Le Calme')
    expect(names[1]).toBe('Le Boony')
  })

  it('row actions link to venue provisioning and content', async () => {
    server.use(
      http.get('/api/metrics/monitor/tonight', () =>
        HttpResponse.json([
          {
            venueId: 'venue-1',
            venueName: 'Le Boony',
            venueType: 'BAR',
            isLive: false,
            liveSince: null,
            goingCount: 0,
            postCountToday: 0,
            recentFeedItems: [],
            quiet: true,
          },
        ])
      )
    )

    renderWithQueryClient(<MonitorContent />)

    await waitFor(() => {
      expect(screen.getByText('Le Boony')).toBeInTheDocument()
    })
    expect(screen.getByRole('link', { name: 'Provisioning' })).toHaveAttribute(
      'href',
      '/venues'
    )
    expect(screen.getByRole('link', { name: 'Contenu' })).toHaveAttribute(
      'href',
      '/promotions'
    )
  })

  it('shows an empty state with no active venues', async () => {
    server.use(
      http.get('/api/metrics/monitor/tonight', () => HttpResponse.json([]))
    )

    renderWithQueryClient(<MonitorContent />)

    await waitFor(() => {
      expect(screen.getByText('Aucun lieu actif.')).toBeInTheDocument()
    })
  })
})
