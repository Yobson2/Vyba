# Vyba Web

The QR-scan surface (ADR-0004, ticket 12) — a separate, lightweight Next.js
app, not the Flutter app and not a Flutter web build. Someone scans a
venue's table-tent QR code on a poor connection; this has to paint
meaningful content in under a second.

A venue page and the public Zone 4 feed, served by the backend's
unauthenticated public API (ticket 12), plus phone-verify "J'y vais"
(ticket 16): mark directly if a session exists, otherwise phone → code →
verify first — the same account as the app for that phone number.

## Commands

```bash
npm install
npm run dev      # http://localhost:3001 (backend defaults to :3000)
npm run build
npm run start
npm run lint
npm run test      # vitest, MSW-mocked API — the project's single test seam
```

## Environment

Copy `.env.example` to `.env.local`:

- `API_BASE_URL` — server-only, used by the RSC data fetches (`lib/api.ts`).
- `NEXT_PUBLIC_API_BASE_URL` — same value, exposed to the browser for the
  client-side attribution/analytics and "J'y vais" calls
  (`components/AttributionCapture.tsx`, `components/GoingSection.tsx`).
- `NEXT_PUBLIC_PLAY_STORE_URL` — optional; the app-download prompt shown
  after a completed "J'y vais" doesn't render until this is set (the app
  isn't published yet).

For local dev against `Vyba-backend`, add `http://localhost:3001` to its
`CORS_ORIGINS`.

## Structure

- `app/[venueId]/page.tsx` — the venue page (server component, fetches on
  every request — `cache: 'no-store'`, since going count / live status are
  time-sensitive).
- `app/zone4/page.tsx` — the public Zone 4 feed, server order, no client
  re-sorting.
- `components/` — presentational pieces (`VenueTonightBlock`, `PromoList`,
  `FeedItemCard`) kept synchronous and prop-driven so they're testable
  without rendering the async server components around them.
- `components/AttributionCapture.tsx` — a client component: captures
  `src`/`venue`/`pid`/`campaign` on a landing, persists them
  (`localStorage`), records the raw landing and fires `qr_landing_opened` —
  all best-effort, never blocking render.
- `components/GoingSection.tsx` — the stateful "J'y vais" flow: marks
  directly with an existing session, otherwise phone → code → verify first;
  bumps the going count optimistically (this page never re-fetches) and
  shows `AppDownloadPrompt` only after a completed mark.
- `lib/api.ts` — typed fetchers against the backend's public read API
  (server-side, RSC).
- `lib/auth-api.ts`, `lib/going-api.ts` — client-side fetchers for the
  phone-OTP and "J'y vais" calls, plus the typed-error → French copy map.
- `lib/session.ts` — the verified session (`localStorage`, since this
  project has no server-side session layer — every backend call is a direct
  client fetch); decodes a token's `exp` client-side before use.
- `lib/client-id.ts` — the per-browser id shared between `AttributionCapture`
  (records the landing) and `GoingSection` (passes it to verify-code) so a
  first-ever signup joins back to its landing event (spec 07).

## Design

Dark-first, brand tokens (`app/globals.css`), no-line rule, ≥8px radii —
mirrors `docs/design-system.md`. System font stack only (no webfont round
trip) and no client UI framework: the performance budget wins any tie
(ADR-0004 — <1s meaningful content where achievable, 2.5s hard ceiling).

## Performance budget

Not independently measured in this environment (no throttled-device QA
harness available here) — built for the budget (React Server Components,
minimal client JS, no map SDK, no icon/font library) but live measurement
on a throttled low-end profile is still a pre-cohort launch gate per spec 14.
