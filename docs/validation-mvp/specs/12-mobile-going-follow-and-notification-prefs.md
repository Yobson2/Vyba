# Spec: mobile-going-follow-and-notification-prefs

> Ready-for-agent spec. Vyba validation MVP critical path (unit 12). Depends on 09, 10, 11, and backend 04, 05, 08.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §4, §8, §12, §17; `docs/adr/0002`; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

"J'y vais" is the wedge — the one action the validation phase most needs users to
take, from the venue page and from event cards in the feed. It must be one tap, show
the live aggregate count, fail honestly when offline, and never queue. Following a
venue and managing the two standing notifications belong to the same mental space:
"the venues I care about and what they're allowed to tell me." The app has none of
this (the old reservation-shaped `bookings` flow was removed in unit 09).

## Solution

A "J'y vais" action on venue pages and event cards: tap to mark (optionally set
party size), see "X personnes y vont ce soir", edit or cancel until midnight, and
get a clear offline failure. A follow/unfollow toggle on venue pages and a "mes
lieux suivis" list in the profile. A compact notification-preferences screen: the
weekend digest toggle, the going-reminder toggle, and per-venue announcement opt-in.

## User Stories

1. As a client, I want one tap on a venue to say "J'y vais" for tonight, so that signalling intent is effortless.
2. As a client, I want to optionally say how many people I'm bringing, so that the venue gets a sense of size.
3. As a client, I want to see the current "X personnes y vont ce soir" count update after I mark, so that I get feedback and see the vibe.
4. As a client, I want to change my party size or cancel before midnight, so that I can adjust.
5. As a client, I want a clear French message if I tap "J'y vais" while offline, so that I don't think it worked.
6. As a client, I want "J'y vais" from an event card in the feed, so that I can act without opening the venue.
7. As a client, I want my "J'y vais" for a venue to be one mark, so that tapping again doesn't double anything.
8. As a client, I want an evening reminder for venues I'm going to (if I've left it on), so that I don't forget.
9. As a client, I want to keep my "J'y vais" private by default and choose to show my identity, so that it's my call.
10. As a client, I want to follow a venue from its page, so that I keep track of it.
11. As a client, I want a "mes lieux suivis" list, so that I can review and unfollow.
12. As a client, I want a notifications screen where I can turn the weekend digest and the going reminder on or off, so that I control what Vyba sends.
13. As a client, I want to opt in to a specific venue's announcements separately from following it, so that following doesn't mean noise.
14. As a client, I want the notification screen to make clear these are the only notifications Vyba sends, so that I trust it stays quiet.
15. As a developer, I want going and follow as Riverpod notifiers with explicit Freezed states, so that marking/loading/error/offline are modelled, not implicit.
16. As a developer, I want the going count on the venue page to refresh on view/refocus (poll-on-view), so that it matches the backend's model.
17. As a platform operator, I want `going_marked`, `going_cancelled`, `venue_followed`, `venue_unfollowed` events emitted, so that the wedge funnel is measurable.
18. As a client, I want an attempt to "J'y vais" on a venue I own (owner account) to be gracefully prevented, so that the rule is clear.

## Implementation Decisions

**Modules touched**

- A `features/going` feature (new; may reuse salvaged party-size/confirmation UI from
  the deleted `bookings` flow) — mark / edit party size / cancel; the aggregate
  count display; the reminder opt-in surfaced here and mirrored to prefs.
- `features/favorites` → refactor into `features/follow` (or keep the folder, rename
  concepts) — follow/unfollow toggle, "mes lieux suivis" list. One concept named
  Follow.
- A small `features/notification_prefs` (or a section under profile/settings) — the
  two toggles + per-venue opt-in management.
- `features/venues` (unit 11) — hosts the "J'y vais" and follow buttons; this unit
  wires them.
- `features/feed` (unit 11) — event card "J'y vais" affordance wired here.

**"J'y vais" behaviour**

- Tap → if offline, immediately show a French "connexion requise" state, do nothing
  else (no queue, per ADR-0002). If online → call the backend `going` mark endpoint
  (resolves tonight's `VenueNight` server-side).
- Optional party-size stepper (default 1). Optional "montrer que c'est moi" toggle
  (identity public).
- After a successful mark: reflect "j'y vais ✓" state and refresh the count.
- Edit/cancel available while before midnight (server enforces; client shows the
  affordance and handles the "trop tard" error after).
- Owner-on-own-venue: the backend rejects; the client shows a friendly "c'est ton
  établissement" state and hides the control where the venue is known to be owned by
  the current user.
- Count display: poll-on-view — fetch on venue page open and on app refocus; no
  websocket.

**Follow behaviour**

- Toggle on the venue page; optimistic with rollback on failure; idempotent.
- "Mes lieux suivis": list from the backend, unfollow inline.

**Notification preferences**

- Weekend digest: on/off (default on). Going reminder: on/off (default on). These
  map to the backend `NotificationPreference`.
- Per-venue announcement opt-in: managed from the venue page ("recevoir les infos de
  ce lieu") and listed on the prefs screen. Explicitly separate from Follow.
- Copy states that these are the only notifications Vyba sends.

**Analytics**

- Emit `going_marked` / `going_cancelled` (with `venue_id`), `venue_followed` /
  `venue_unfollowed`. A Zone 4 `going_marked` flips `active_zone`.

## Testing Decisions

**Good test:** drives the going and follow notifiers with fake datasources and
asserts observable state — marking online transitions to a "going" state and
re-fetches the count; marking offline yields the "connexion requise" state and makes
no datasource call; a second mark is a no-op; cancel returns to the un-marked state;
follow is optimistic and rolls back on error. A widget test on the venue page
asserts the "J'y vais" button shows the count, hides for an owned venue, and the
follow toggle reflects state.

**Seam:** the **notifier ↔ use case** boundary with fake datasources. One venue-page
widget test for the button states. Time-boundary ("before midnight") is the
backend's to enforce; the client test only checks it surfaces the "trop tard" error.

**Modules under test:** `features/going`, `features/follow`, the notification-prefs
state.

**Prior art:** `docs/mobile.md` notifier/state conventions; the `favorites` feature's
existing toggle notifier as a starting shape for follow.

**Representative cases:** online mark → going state + count refresh call; offline
mark → "connexion requise", no call; mark twice → single going state; cancel →
un-marked; follow then fail → toggle rolls back; digest toggle off → preference
update call; per-venue opt-in is independent of the follow state for the same venue.

## Out of Scope

- Sending the reminder / digest / broadcasts (backend unit 08); this unit only sets
  preferences and opt-ins.
- The going aggregate, milestones, abuse rules (backend unit 04).
- User night-photo *upload* from the venue page — **decide in review**: fits here
  (venue-relationship action) or unit 11. This spec assumes a thin "ajouter une
  photo" entry that calls the `media` upload endpoint (backend unit 06); full photo
  UX can be a follow-on.
- "Which friends are going" / social graph.
- The owner-side view of who's going (unit 13).

## Further Notes

- ADR-0002: soft intent, no reservation, fails-not-queues offline. The offline
  behaviour is a correctness requirement, not a nicety.
- Follow ≠ announcement opt-in — the prefs screen must make this legible.
- If a review decides night-photo upload belongs in unit 11, move the thin entry
  there; it's noted in both.
