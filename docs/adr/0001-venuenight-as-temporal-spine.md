# ADR-0001: VenueNight as the temporal spine

## Status

Accepted (2026-09-10)

## Context

Nightlife information is intensely time-bound. Almost everything Vyba shows about a
venue is really about *a venue on a particular night*: whether it's live, who's
playing, tonight's promo, how many people say they're going, photos from that
night. A Saturday's state is meaningless by Sunday.

The obvious first design is to hang this state on the `Venue` record as mutable
fields — `is_live`, `going_count`, `live_since`, `tonight_headline` — and reset
them each day. That approach leaks: the daily reset becomes a fragile cron
concern, historical questions ("how did going activity correlate with engagement
last weekend?") become impossible without a separate audit trail, and every read
has to reason about staleness.

The validation experiment specifically needs clean per-night data to answer
whether the core loop works.

## Decision

Introduce **`VenueNight`** as a first-class domain entity: one record per
`(venue, calendar night)`. All night-scoped state belongs to a `VenueNight` —
live status and its timestamp, the going list and aggregate count, the night
headline / DJ, night-specific promotions and photos, and per-night engagement
rollups.

`Venue` holds only durable facts (identity, location, type, ownership). It must
not carry resettable night state.

"What's happening tonight?" is a query for `VenueNight` where the date is today.
The daily "reset" is simply that a new night has a new record.

## Rationale

- The daily reset disappears — it's structural, not a job.
- Per-night analytics fall out for free; the going/engagement correlation the
  validation gate needs is a straightforward query.
- Reads are unambiguous: a `VenueNight` is either today's or it isn't.
- Feed items, the going signal, and tonight's promo all get a single natural thing
  to reference.

## Consequences

- Every night-scoped feature (going, live status, feed "tonight" ranking, the
  VenueNight monitor in the dashboard) depends on this entity; it is on the
  critical path and built in the first backend milestone.
- Code reviews must guard against night state creeping back onto `Venue`.
- A `VenueNight` needs to be created lazily (first activity of the night) or
  provisioned; the exact trigger is an implementation detail.
- Realtime updates are explicitly out of scope for validation — the going count on
  a `VenueNight` is read by polling, not pushed.
