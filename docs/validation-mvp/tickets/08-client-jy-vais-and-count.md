# 08: Client marks "J'y vais"; count shows to client and owner

**What to build:** From a venue page, a client taps "J'y vais" for tonight
(optionally a party size), and sees "X personnes y vont ce soir". They can edit the
party size or cancel until midnight. Tapping while offline fails cleanly with no
queued signal. The owner sees the count and rough party sizes on their home
screen. An owner cannot mark their own venue. Going is an independent capability —
it does **not** depend on the feed.

**Blocked by:** 06 (owner live tonight — provides the `VenueNight`).

**Specs:** `../specs/04-going.md`, `../specs/12-mobile-going-follow-and-notification-prefs.md`, `../specs/13-mobile-owner-shell.md`; `../../adr/0002-soft-jy-vais-intent-instead-of-reservations.md`.
**Seam:** backend HTTP e2e (count after mark/cancel sequences, owner-refusal,
time-boundary via an injected clock); mobile notifier↔usecase.

**Status:** ready-for-agent

- [ ] Backend: `Going` record (userId, venueNightId, partySize, identityPublic, timestamps, canceledAt); at most one active mark per (user, venue-night).
- [ ] Backend: mark resolves tonight's `VenueNight` (get-or-create), rejects if the principal owns the venue, rejects on rate-limit; edit/cancel allowed only before the night's Abidjan midnight.
- [ ] Backend: `VenueNight.goingCount` = active marks; cheap to read; public display is tonight-only and resets by being per-night.
- [ ] Backend: repeat-submission abuse guarded (per-user churn limit, per-session/IP).
- [ ] Backend: **decision** — the public count is the number of people who marked, not the sum of party sizes (party size is texture for the owner). Confirm in review.
- [ ] Mobile client: "J'y vais" button on the venue page (and on feed event cards once ticket 07/09 provide them) — optional party-size stepper, optional "montrer que c'est moi"; offline tap → immediate "connexion requise", no call, no queue.
- [ ] Mobile client: after marking, show "j'y vais ✓" and refresh the count (poll-on-view); edit/cancel before midnight; a friendly "c'est ton établissement" state for an owned venue.
- [ ] Mobile owner: going count + rough party sizes on the owner home; no approve/respond action.
- [ ] `going_marked` / `going_cancelled` events emitted; a Zone 4 mark contributes to `active_zone` (full wiring ticket 11).
- [ ] Demo: a client taps "J'y vais avec 3" → "3 personnes y vont ce soir" wait — count shows **1** (one mark); a second client marks → 2; owner home shows "2"; first client cancels → 1; the owner account's own "J'y vais" is refused.
