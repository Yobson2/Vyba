import { server } from '@/test/msw/server'
import { renderWithQueryClient } from '@/test/render'
import { screen, waitFor } from '@testing-library/react'
import { http, HttpResponse } from 'msw'
import { describe, expect, it } from 'vitest'
import { MetricsContent } from '../metrics'

function mockMetricsHandlers(overrides: { bySource?: boolean } = {}) {
  server.use(
    http.get('/api/metrics/zone4-wau', () => HttpResponse.json({ wau: 312 })),
    http.get('/api/metrics/retention', () =>
      HttpResponse.json({
        overall: {
          week1: { cohortSize: 100, retained: 40, rate: 0.4 },
          week2: { cohortSize: 80, retained: 25, rate: 0.3125 },
          week4: { cohortSize: 50, retained: 9, rate: 0.18 },
        },
        bySource: overrides.bySource
          ? {
              qr: {
                week1: { cohortSize: 30, retained: 15, rate: 0.5 },
                week2: { cohortSize: 25, retained: 10, rate: 0.4 },
                week4: { cohortSize: 15, retained: 4, rate: 0.267 },
              },
              promoter: {
                week1: { cohortSize: 20, retained: 8, rate: 0.4 },
                week2: { cohortSize: 15, retained: 5, rate: 0.333 },
                week4: { cohortSize: 10, retained: 2, rate: 0.2 },
              },
              social: {
                week1: { cohortSize: 10, retained: 2, rate: 0.2 },
                week2: { cohortSize: 8, retained: 1, rate: 0.125 },
                week4: { cohortSize: 5, retained: 0, rate: 0 },
              },
            }
          : {},
      })
    ),
    http.get('/api/metrics/organic-posting', () =>
      HttpResponse.json({ organicVenueCount: 11, totalVenueCount: 30 })
    ),
    http.get('/api/metrics/going-per-night', () =>
      HttpResponse.json([
        { date: '2026-01-02', total: 40 },
        { date: '2026-01-03', total: 65 },
      ])
    ),
    http.get('/api/metrics/active-venues', () =>
      HttpResponse.json({ count: 28 })
    ),
    http.get('/api/metrics/content-activity', () =>
      HttpResponse.json({ PROMO: 12, EDITORIAL: 3 })
    )
  )
}

describe('Validation metrics', () => {
  it('renders each gate metric against its target, with a definition line', async () => {
    mockMetricsHandlers()
    renderWithQueryClient(<MetricsContent />)

    await waitFor(() => {
      expect(screen.getByText('312 / ~500')).toBeInTheDocument()
    })
    expect(screen.getByText('18% / ≥ 25%')).toBeInTheDocument()
    expect(screen.getByText('11 / ~30 (≥ 15 / ~30)')).toBeInTheDocument()
    expect(screen.getByText('28')).toBeInTheDocument()

    // Every card renders its locked definition text.
    expect(
      screen.getByText(/activeZone = zone_4 et au moins une action/)
    ).toBeInTheDocument()
  })

  it('renders retention by source when the mock includes segments', async () => {
    mockMetricsHandlers({ bySource: true })
    renderWithQueryClient(<MetricsContent />)

    await waitFor(() => {
      expect(screen.getByText('qr')).toBeInTheDocument()
    })
    expect(screen.getByText('promoter')).toBeInTheDocument()
    expect(screen.getByText('social')).toBeInTheDocument()
  })

  it('renders PostHog outbound links', async () => {
    mockMetricsHandlers()
    renderWithQueryClient(<MetricsContent />)

    await waitFor(() => {
      expect(
        screen.getByRole('link', { name: /Zone 4 WAU cohort/ })
      ).toBeInTheDocument()
    })
  })
})
