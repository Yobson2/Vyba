# Spec: notifications

> Ready-for-agent spec. Vyba validation MVP (unit 8).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §12, §19; `docs/adr` (none specific); `CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

A nightlife app that over-notifies is uninstalled faster than one with a thin feed.
But two notifications genuinely help someone decide where to go: a Thursday-evening
"here's Zone 4 this weekend" digest, and an ~20:00 reminder for venues they said
they'd go to tonight. Venues also occasionally have something worth pushing to
tonight's "going" crowd — but only if the user opted into that venue, and at most
once a night.

The backend has Firebase Admin available in `common/firebase` but no notification
logic, scheduling, preferences, or opt-in model.

## Solution

Exactly two standing scheduled notifications, plus opt-in per-venue broadcasts
rate-limited to one per venue per night. Push delivery via FCM (Android). Users
have a small preference set (digest on/off, going-reminder on/off, per-venue
broadcast opt-in). Every send is recorded so frequency caps and analysis work.

## User Stories

1. As a client, I want a Thursday-evening digest of what's happening in Zone 4 this weekend, so that I can make plans.
2. As a client, I want an evening reminder for venues I marked "J'y vais" tonight, so that I don't forget my own plan.
3. As a client, I want to turn either standing notification off, so that I stay in control.
4. As a client, I want to opt in to a specific venue's announcements, so that I hear from the venues I care about.
5. As a client, I want opting into a venue's announcements to be a separate choice from following it, so that following doesn't spam me.
6. As a client, I want at most one broadcast from a given venue per night, so that a venue can't flood me.
7. As a client, I want tapping a notification to open the right place (the digest → the feed; the reminder → the venue; a broadcast → that venue), so that it's useful.
8. As a client, I want no other notifications during validation, so that the app stays quiet.
9. As a venue owner, I want to send one announcement to tonight's "going" list, so that I can tell them about a change or a highlight.
10. As a venue owner, I want to be stopped from sending a second broadcast the same night, so that I don't burn my audience (and the limit protects me).
11. As the Vyba team, I want the digest content assembled from the current Zone 4 feed (top weekend items), so that it doesn't need separate authoring.
12. As a platform operator, I want every notification send recorded with type, recipient, timestamp and result, so that delivery and opt-out trends are visible.
13. As a platform operator, I want a user with no valid device token to be skipped cleanly, so that failures don't block a batch.
14. As a developer, I want the going unit to tell me who to remind tonight, so that the reminder job doesn't reach into `Going` internals.
15. As a developer, I want scheduled jobs on the existing queue infrastructure, so that there's no new scheduler.
16. As a security reviewer, I want notification payloads free of PII beyond what's necessary (venue name, counts — never phone numbers), so that a delivered notification isn't a leak.

## Implementation Decisions

**Module**

- New `notifications` module — device token registration, a `NotificationPreference`
  per user, a `SentNotification` log, the two scheduled jobs, the broadcast
  endpoint, and the FCM sender (wrapping `common/firebase`). Jobs run on
  `common/queues` (BullMQ).

**Device tokens**

- Endpoint for the app to register/refresh an FCM token for the current user
  (multiple devices allowed). Invalid tokens are pruned on send failure.
- The web surface does not do push in v1 — web has no notifications.

**Preferences (`NotificationPreference`)**

- `userId`, `weekendDigest` (default on), `goingReminder` (default on).
- Per-venue broadcast opt-in: a separate `VenueBroadcastOptIn` record `(userId,
  venueId)` — **not** implied by `Follow`.

**Standing notification 1 — weekend digest**

- Scheduled Thursday ~17:00 Abidjan.
- Recipients: users with `weekendDigest = on` and an `activeZone` of the launch area
  (or acquired there) — keep it to the cohort.
- Content: assembled from the `feed` ranking endpoint's top upcoming/weekend items
  for the launch area. Deep-links to the feed.

**Standing notification 2 — going reminder**

- Scheduled daily ~20:00 Abidjan.
- Recipients: from the `going` unit's "reminder recipients tonight" query
  (`(userId, venueId)` with an active `Going` for today), filtered to
  `goingReminder = on`.
- Content: "Tu as dit que tu allais à {venue} ce soir." Deep-links to the venue.
- One reminder per user per night even if they marked several venues (batch into one
  notification listing them, or send per venue — recommend one grouped notification).

**Venue broadcasts**

- Endpoint: `VENUE_OWNER` (own venue) posts a short message. Authorised + handed the
  recipient set by the `going` unit (tonight's active "going" for that venue) ∩
  users with a `VenueBroadcastOptIn` for that venue ∩ `broadcast`-allowing prefs.
- Rate limit: one successful broadcast per venue per night (enforced via the
  `SentNotification` log / a Redis guard).
- Content is owner-authored, length-capped, no arbitrary data payload. Deep-links to
  the venue.

**Send + logging**

- `SentNotification`: `id`, `type` ∈ { `weekend_digest`, `going_reminder`,
  `venue_broadcast` }, `userId`, `venueId?`, `sentAt`, `result` ∈ { `delivered`,
  `no_token`, `failed` }.
- The FCM sender skips users with no valid token, prunes tokens FCM reports as
  invalid, and never fails a whole batch on one bad recipient.

**Authorization**

- Register token / set preferences / manage opt-ins: the authenticated `CLIENT`.
- Broadcast: `VENUE_OWNER` for their own venue.
- Scheduled jobs: system.

**Analytics**

- Emit events for notification sent / opened / opt-out toggled (taxonomy owned by
  unit 7; extend if needed).

## Testing Decisions

**Good test:** drives the scheduled-job entry points and the broadcast endpoint
directly (invoke the job function via its HTTP/test trigger, not by waiting for a
cron) and asserts who would be sent to and what's recorded — a user who opted out of
the digest is not a recipient; the reminder recipients match the active `Going`
rows; a second broadcast the same night is refused; a recipient with no token is
logged `no_token`, not an error. Uses a **fake FCM sender** that records
"deliveries".

**Seam:** backend HTTP API + directly invocable job functions, with a fake FCM
sender and a controllable clock (for "Thursday 17:00" / "20:00" logic). Reuse units
1–4 for users, venues, going.

**Modules under test:** `notifications`, with `going` and `feed` as fixture support.

**Prior art:** units 1–7 e2e specs; `common/queues` and `common/firebase` usage per
`docs/backend.md`.

**Representative cases:** digest job → only opted-in cohort users, content
references current weekend feed items; reminder job → matches active `Going`,
respects `goingReminder = off`; user marked 2 venues → one grouped reminder; owner
broadcast → reaches opted-in ∩ going users only; second broadcast same night →
refused; broadcast to a user with no device token → `no_token` logged, batch
completes; following a venue without opting into broadcasts → not a broadcast
recipient.

## Out of Scope

- iOS / APNs (Android-first, MVP spec §15).
- Web push.
- Any notification type beyond the three defined here.
- The digest's editorial voice / copywriting (ops) — this unit assembles from feed
  items.
- In-app notification centre UI and the client preference screens (client units) —
  this unit provides the endpoints.
- Quiet hours / per-user send-time optimisation.

## Further Notes

- The "notifications help you decide, they don't interrupt" principle is MVP spec
  §12 — resist adding types.
- Broadcast opt-in is deliberately decoupled from Follow (`follows` unit Further
  Notes, MVP spec §12).
- The reminder and broadcast recipient sets come from the `going` unit's internal
  query — this unit must not query `Going` directly.
