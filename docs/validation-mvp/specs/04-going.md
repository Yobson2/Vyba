# Spec: going ("J'y vais")

> Ready-for-agent spec. Vyba validation MVP critical path (unit 4 of 4).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §4, §19; `docs/adr/0002-soft-jy-vais-intent-instead-of-reservations.md`; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The "Décide → J'y vais" step is the heart of Vyba's core loop and one of the five
things the validation phase must measure. Neighbourhood bars and *maquis* are
walk-in culture — they will not run a reservation book. So Vyba needs a signal that
someone has decided to go out tonight that costs the venue nothing and costs the
user one tap, while still being trustworthy enough to build a metric and a feed
ranking signal on.

The backend has nothing for this. The mobile app has a `bookings` feature (mock,
reservation-shaped) that is being removed.

## Solution

A user marks **"J'y vais"** for a venue tonight, optionally with a party size. It is
an intent signal, not a reservation — no table is held, the owner does not approve.
The public view is an **aggregate count for tonight only** ("23 personnes y vont ce
soir"); the user's identity is private unless they opt in. One active mark per user
per venue per night, editable or cancellable until midnight, and the aggregate is
inherently per-night so it "resets" on its own. Owners cannot mark their own venue.
Repeat-submission abuse is blocked server-side. The count feeds feed ranking and
triggers `going_milestone` feed items.

## User Stories

1. As a client, I want to tap "J'y vais" on a venue for tonight, so that I signal I'm going in one action.
2. As a client, I want to optionally say how many people I'm coming with, so that the venue and other users get a sense of the size.
3. As a client, I want to see the current number of people going tonight, so that I can gauge whether it'll be busy.
4. As a client, I want my identity hidden by default, so that saying I'm going isn't a public statement.
5. As a client, I want to opt in to showing my identity, so that friends can see I'm going if I choose.
6. As a client, I want to change my party size or cancel before midnight, so that I can adjust plans.
7. As a client, I want "J'y vais" to only count for tonight and be gone tomorrow, so that the number always means "tonight".
8. As a client, I want a clear failure if I'm offline when I tap, so that I don't believe a signal was sent when it wasn't.
9. As a client, I want to only be able to mark a given venue once per night, so that the count reflects people, not taps.
10. As a client, I want an optional reminder in the evening for venues I said I'd go to, so that I don't forget my own plan.
11. As a venue owner, I want to see how many people are going tonight and rough party sizes, so that I can prepare — without having to confirm anything.
12. As a venue owner, I want to not be able to inflate my own count, so that the number stays credible.
13. As a venue owner, I want an optional one-tap broadcast to tonight's "going" list, so that I can tell them about something — but only if I choose to.
14. As the Vyba team, I want a milestone feed item when a venue crosses an attendance threshold tonight, so that momentum shows in the feed.
15. As a platform operator, I want "going" activity recorded per venue-night with timestamps, so that I can measure going activity across weekend nights.
16. As a platform operator, I want obvious abuse (rapid repeated marks from one account or session) blocked, so that the metric can't be trivially gamed.
17. As a platform operator, I want to know, per night, who to send the evening reminder to, so that the notifications unit can act on it.
18. As a developer, I want marking "J'y vais" to attach to the venue's `VenueNight` (get-or-create), so that the count lives on the night, not the venue.
19. As a developer, I want the aggregate count exposed on the `VenueNight` for cheap reads by feed ranking and the venue view.
20. As a web user, I want "J'y vais" to work from the QR page once my phone is verified, so that the highest-intent moment converts.
21. As a reviewer, I want the "one per user per venue per night" and "no self-marking" rules enforced at the domain level, so that they can't be bypassed by calling the API directly.

## Implementation Decisions

**Module**

- New `going` module — the `Going` record, mark / update / cancel endpoints, the
  per-venue-night aggregate, the milestone trigger, and a query for "reminder
  recipients tonight".

**`Going` entity**

- `id`, `userId`, `venueNightId`, `partySize` (int ≥ 1, default 1),
  `identityPublic` (bool, default false), `createdAt`, `updatedAt`, `canceledAt`
  (nullable).
- An "active" mark is one with `canceledAt IS NULL`.
- Uniqueness: at most one active `Going` per `(userId, venueNightId)`. Re-marking
  after cancelling the same night reactivates / creates anew (allowed — it's still
  one active mark).

**Mark / edit / cancel**

- Mark: input = venueId (+ optional partySize, identityPublic). Backend resolves
  tonight's `VenueNight` via get-or-create, rejects if the principal owns that venue
  (`AccountIsVenueOwnerError` or similar typed exception), rejects if a rate limit
  trips, else creates the active `Going`.
- Edit: change `partySize` / `identityPublic` while `now()` is before the night's
  midnight boundary (Abidjan). After midnight: locked.
- Cancel: sets `canceledAt`, allowed until the same midnight boundary. After
  midnight the mark is historical and immutable.
- All three require connectivity — there is no queued/offline path (client
  concern; backend simply has no "pending" state).

**Aggregate count**

- `VenueNight.goingCount` = number of active `Going` for that night. Maintained
  transactionally on mark/cancel (recommended) or computed; reads must be O(1)-ish
  for feed ranking.
- Public display uses this count and is inherently "tonight" — no reset job needed;
  a new night has its own `VenueNight` with its own count.
- The count excludes nothing based on identity privacy — `identityPublic` only
  governs whether a name/avatar is shown in any "who's going" view, not whether the
  person is counted.

**Owner cannot self-inflate**

- Enforced in the mark path: if `principal.userId == venue.ownerUserId`, reject.
- Additionally, any "who's going" list shown to an owner must not offer the owner a
  way to add themselves.

**Abuse protection**

- Per-user rate limit on mark/cancel churn (e.g. max N mark/cancel cycles per venue
  per night) in Redis.
- Per-session/IP limit on distinct marks in a short window.
- These are guardrails, not a fraud system — proportionate to a 500-user cohort.

**Milestones**

- On each successful mark, if the new `goingCount` crosses a configured threshold
  (recommended 10, 25, 50) for that `VenueNight` and no milestone item exists yet
  for that (venueNight, threshold), call the `feed` module to emit a
  `going_milestone` `FeedItem` (`origin = user`-adjacent / system; `feed` decides
  the exact origin value for system items). Idempotent per threshold.

**Reminder recipients**

- Expose an internal query: for a given date, the set of `(userId, venueId)` with an
  active `Going` — consumed by the `notifications` unit for the ~20:00 reminder.
  This unit does not send anything.

**Owner broadcast**

- An owner endpoint to send one message to tonight's active "going" users for their
  venue. Rate-limited to ~1 per venue per night (MVP spec §12). Delivery is the
  `notifications` unit's job; this unit authorises and hands off the recipient set +
  message. **Recommend: interface only in this unit, full wiring in the
  notifications unit** — keep the `going` unit about intent, not delivery.

**Authorization**

- Mark / edit / cancel / view own: any authenticated `CLIENT` (app or web verified
  session).
- Owner count view + broadcast: `VENUE_OWNER` for their own venue.
- Reminder-recipients query: internal only.

## Testing Decisions

**Good test:** drives the mark/edit/cancel endpoints and the venue/venue-night read
over HTTP and asserts observable outcomes — the aggregate count after a sequence of
marks and cancels, that a second mark by the same user doesn't increment, that the
venue owner is refused, that editing after the midnight boundary is refused, that
crossing a threshold produces exactly one milestone feed item. It does not assert on
the counter column mechanism or Redis keys.

**Seam:** backend HTTP API — the unit-1 e2e seam. Reuse the auth helper (client,
owner tokens) and units 2–3 for venue/venue-night/feed fixtures. Time-boundary
cases use a controllable clock (inject a time source rather than sleeping).

**Modules under test:** `going`, with `venue-nights` (aggregate) and `feed`
(milestone) observed through their read surfaces.

**Prior art:** units 1–3 e2e specs; `docs/backend.md` conventions; typed domain
exceptions pattern.

**Representative cases:** user marks → count 1; same user marks again → still 1;
second user marks with partySize 3 → count 2 (party size is metadata, count is
people-marks — confirm intended: **count = number of active marks, not sum of party
sizes**); user cancels → count back to 1; owner tries to mark own venue → 403/typed
error; user edits party size before midnight → ok; user edits after midnight → refused;
count crosses 10 → one `going_milestone` in the feed; crossing 10 again after a
cancel+remark → no duplicate milestone; "tomorrow" the venue's `VenueNight` count is
0 (fresh night); reminder-recipients query returns the right set.

## Out of Scope

- Real table / VIP booking (post-validation, ADR-0002).
- Sending the evening reminder and the owner broadcast (notifications unit) — this
  unit exposes the recipient set and authorises the broadcast only.
- Proximity / geofence confirmation of attendance — explicitly deferred (MVP spec
  §4); no proximity capture in this unit.
- "Who's going" social UI, friend graph, seeing which friends are going.
- The mobile/web "J'y vais" UI and its offline-failure UX (their own units).
- Anonymous / unauthenticated marking — impossible by design (ADR-0003).

## Further Notes

- ADR-0002 records why this is soft intent and not a reservation; the count's
  trustworthiness is an invariant in `Vyba-backend/CONTEXT.md`.
- Decision to confirm with the team during review: **the public count is the number
  of people who marked, not the sum of their party sizes.** Party size is shown to
  the owner as texture ("rough party sizes") but the headline number is mark count.
  This spec assumes that; flag if the intent was sum-of-party-sizes.
- If validation shows users won't take even this one-tap action, that is a finding
  about the loop (MVP spec §23.4), not a UX bug — instrument the funnel accordingly
  (attribution-and-analytics unit).
