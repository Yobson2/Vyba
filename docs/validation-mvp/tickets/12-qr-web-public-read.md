# 12: QR web — public read API + fast venue page + read-only Zone 4 feed

**What to build:** A new lightweight web app. Someone scans a venue's QR code and,
on a poor connection, sees the venue's page — identity, tonight's status, going
count, tonight's promo/event, address — plus a link to a read-only Zone 4 feed.
Served from a new unauthenticated, read-only, rate-limited public API. No actions
yet (the "J'y vais" flow is ticket 16).

**Blocked by:** 06 (venue + `VenueNight`), 07 (feed).

**Specs:** `../specs/14-qr-web-surface.md`, and the public-read sections of `../specs/02-venue-night-model.md` and `../specs/03-feed.md`; `../../adr/0004-separate-lightweight-web-surface.md`.
**Seam:** web route/page integration with a mocked API (MSW) — establish MSW as the
project's single test seam; plus a backend e2e case for the public endpoints.

**Status:** ready-for-agent

- [ ] Backend: unauthenticated, read-only, rate-limited public endpoints — venue detail (+ today's `VenueNight`) and the Zone 4 feed. Public/PII-free fields only: no "who's going" identities, no follower data, no owner data, no mutations. Does not widen the authenticated payload or weaken existing authorization. Abuse-monitored.
- [ ] Web: a new project (e.g. `Vyba-web/`) — React/Next or comparably light; its own build, deploy, test setup; French only.
- [ ] Web: `/{venue}` renders identity, tonight's state (live + `liveSince`, headline, "X personnes y vont ce soir"), tonight's promo/event, address + "Ouvrir dans Google Maps" (link, no embedded map), a link to `/zone4`; "rien d'annoncé ce soir" when there's no `VenueNight`.
- [ ] Web: `/zone4` renders the public feed in server order; items open their venue page; no actions.
- [ ] Web: `src`/`venue`/`pid`/`campaign` query params captured and persisted for the session (used by ticket 16); `qr_landing_opened` emitted where the analytics core (ticket 11) is available.
- [ ] Web: meaningful venue content visible < 1s where achievable, 2.5s hard ceiling on a throttled mobile profile / low-end device — measured.
- [ ] Web: design pass (dark, brand tokens, no-line) — speed budget wins ties.
- [ ] Demo: open `/{venue}?src=qr&venue=V1` on a throttled connection → the venue page paints fast with tonight's state and count; tap through to `/zone4` and read the feed; no login prompt anywhere in this flow.
