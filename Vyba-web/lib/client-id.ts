'use client';

const CLIENT_ID_KEY = 'vyba_client_id';

/**
 * A stable per-browser id — the join key between a landing event
 * (`POST /api/attribution/landing`) and the signup it eventually produces
 * (spec 07/14). Shared between `AttributionCapture` (records the landing)
 * and the "J'y vais" verify flow (passes it as `clientId` to verify-code)
 * so both name the same visit.
 */
export function getOrCreateClientId(): string {
  const existing = localStorage.getItem(CLIENT_ID_KEY);
  if (existing) return existing;
  const id =
    typeof crypto.randomUUID === 'function'
      ? crypto.randomUUID()
      : `${Date.now()}-${Math.random().toString(16).slice(2)}`;
  localStorage.setItem(CLIENT_ID_KEY, id);
  return id;
}
