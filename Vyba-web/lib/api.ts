import type { PublicFeedItem, VenueDetail } from './types';

/**
 * Server-only base URL for the RSC data fetches (venue page, /zone4) — kept
 * out of the client bundle. The client-side attribution/analytics calls use
 * `NEXT_PUBLIC_API_BASE_URL` instead (see `components/AttributionCapture`).
 */
function apiBaseUrl(): string {
  const url = process.env.API_BASE_URL ?? process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!url) {
    throw new Error('API_BASE_URL is not configured');
  }
  return url;
}

/** The unauthenticated, read-only, rate-limited public venue read (ticket 06/12). */
export async function getVenuePublic(venueId: string): Promise<VenueDetail | null> {
  const res = await fetch(`${apiBaseUrl()}/api/venues/${venueId}/public`, {
    cache: 'no-store',
  });
  if (res.status === 404) return null;
  if (!res.ok) {
    throw new Error(`Failed to load venue ${venueId}: ${res.status}`);
  }
  return (await res.json()) as VenueDetail;
}

/** The unauthenticated, read-only, rate-limited public Zone 4 feed (ticket 07/12). */
export async function getZone4Feed(): Promise<PublicFeedItem[]> {
  const res = await fetch(`${apiBaseUrl()}/api/feed/public`, {
    cache: 'no-store',
  });
  if (!res.ok) {
    throw new Error(`Failed to load the Zone 4 feed: ${res.status}`);
  }
  return (await res.json()) as PublicFeedItem[];
}
