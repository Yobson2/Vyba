# 06: Owner marks the venue live tonight; client sees it on the venue page

**What to build:** From the owner shell, one tap marks the venue live for tonight
and sets an optional headline / DJ. A client opens that venue in the app and sees
the live status (with "depuis 21h30"), the headline, and — when nothing is on —
a clear "rien d'annoncé ce soir" state. Introduces the `VenueNight` aggregate.

**Blocked by:** 05 (provision a venue + owner).

**Specs:** `../specs/02-venue-night-model.md` (VenueNight), `../specs/13-mobile-owner-shell.md` (live action), `../specs/11-mobile-feed-and-venue-discovery.md` (venue detail).
**Seam:** backend HTTP e2e; mobile notifier↔usecase + a venue-detail widget test.

**Status:** ready-for-agent

- [ ] Backend: `VenueNight` entity keyed `(venueId, date)` unique, Abidjan-local date; `isLive` + `liveSince` + `liveSetBy`; `headline` / `djName`; no night state on `Venue`.
- [ ] Backend: get-or-create for "this venue tonight" (used internally); owner set-live (idempotent on/off) + set-headline endpoints, guarded by `VENUE_OWNER` + ownership check.
- [ ] Backend: public venue detail = durable profile + today's `VenueNight` (or a "no activity tonight" shape). Both an authenticated read and the start of the unauthenticated public read path (full public payload for the app; the QR-web variant is ticket 12).
- [ ] Mobile owner: "on est live ce soir" toggle + headline field on the owner home; toggling twice is a no-op.
- [ ] Mobile client: venue detail renders profile (FCFA price, type, address, "Ouvrir dans Google Maps") + a tonight block (live + `liveSince` relative time + headline) or "rien d'annoncé ce soir".
- [ ] Demo: owner taps live + sets "DJ Kobo ce soir"; a client opens the venue and sees "C'est live · depuis 22h00 · DJ Kobo"; owner toggles off → client sees "rien d'annoncé ce soir".
