'use client';

import { refreshSession } from './auth-api';
import { clearSession, getSession, isExpired, setSession } from './session';

function apiBaseUrl(): string {
  const url = process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!url) throw new Error('NEXT_PUBLIC_API_BASE_URL is not configured');
  return url;
}

/** No usable session — the caller should fall back to the phone/code flow. */
export class NoSessionError extends Error {}

/**
 * "J'y vais" for an existing session (spec 14): refreshes the access token
 * first if it's expired (or already gone), so a session from an earlier
 * visit needs no new code. Party size optional; identity private by
 * default — mirrors the app's `MarkGoingDto` exactly.
 */
export async function markGoing(
  venueId: string,
  options: { partySize?: number } = {},
): Promise<void> {
  let session = getSession();
  if (!session) throw new NoSessionError();

  if (isExpired(session.accessToken)) {
    try {
      const refreshed = await refreshSession(session.refreshToken);
      setSession(refreshed);
      session = refreshed;
    } catch {
      clearSession();
      throw new NoSessionError();
    }
  }

  const res = await fetch(`${apiBaseUrl()}/api/going`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${session.accessToken}`,
    },
    body: JSON.stringify({
      venueId,
      partySize: options.partySize,
      identityPublic: false,
    }),
  });

  if (res.status === 401) {
    clearSession();
    throw new NoSessionError();
  }
  if (!res.ok) {
    throw new Error(`Failed to mark "J'y vais": ${res.status}`);
  }
}
