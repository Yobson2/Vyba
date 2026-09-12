'use client';

import { useEffect } from 'react';
import { useSearchParams } from 'next/navigation';
import { getOrCreateClientId } from '@/lib/client-id';

const ATTRIBUTION_KEY = 'vyba_attribution';

/**
 * Captures `src`/`venue`/`pid`/`campaign` on a QR/campaign landing (spec
 * 07/14), persists them for the session so ticket 16's "J'y vais" phone
 * flow can reuse them, records the raw landing (`POST
 * /api/attribution/landing`) and fires `qr_landing_opened` through the
 * analytics proxy — both best-effort, never blocking render (renders
 * nothing itself). A no-op when the page has no `src` param (i.e. every
 * load that isn't the actual landing).
 */
export function AttributionCapture({
  venueIdFallback,
}: {
  venueIdFallback?: string;
}) {
  const searchParams = useSearchParams();

  useEffect(() => {
    const src = searchParams.get('src');
    if (!src) return;

    const venueId = searchParams.get('venue') ??
      (src === 'qr' ? venueIdFallback : undefined) ??
      undefined;
    const promoterId = searchParams.get('pid') ?? undefined;
    const campaignId = searchParams.get('campaign') ?? undefined;
    const clientId = getOrCreateClientId();

    localStorage.setItem(
      ATTRIBUTION_KEY,
      JSON.stringify({ src, venueId, promoterId, campaignId }),
    );

    const apiBase = process.env.NEXT_PUBLIC_API_BASE_URL;
    if (!apiBase) return;

    void fetch(`${apiBase}/api/attribution/landing`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        src,
        venueId,
        promoterId,
        campaignId,
        surface: 'web',
        clientId,
      }),
    }).catch(() => {});

    void fetch(`${apiBase}/api/analytics/track`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        event: 'qr_landing_opened',
        anonymousId: clientId,
        properties: { source: src, venue_id: venueId },
      }),
    }).catch(() => {});
    // Runs once per distinct query-param combination on this page.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams]);

  return null;
}
