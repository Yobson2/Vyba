# ADR-0006: Optional per-venue reservations

## Status

Accepted (2026-09-13)

## Context

ADR-0002 made "J'y vais" the primary intent signal because the launch venues
are walk-in bars and *maquis* with no reservation infrastructure — forcing a
booking workflow on them risked losing venue supply on day one. That ADR
explicitly deferred real booking, but only for a named subset: "the subset of
higher-end lounges where that behaviour already exists."

The product now needs that subset activated: when a client finds a venue,
they should see roughly how full it is, and — where the venue actually takes
reservations — be able to request one.

## Decision

Two additive changes, both **opt-in per venue** and admin-set (no self-serve,
consistent with how every other venue attribute is provisioned):

- `Venue.capacity` (nullable int) — a declared seating/standing capacity.
  Drives a client-facing quiet/busy/full gauge computed from `capacity` vs.
  `VenueNight.goingCount` — no new aggregate, reuses what `going` already
  maintains.
- `Venue.reservationsEnabled` (default `false`) — when true, the venue's
  detail page shows a reservation request flow (new `reservations` module,
  modeled closely on `going`: same-night only, same self-book and rate-limit
  guardrails). The owner confirms or rejects each request from the owner app.
  Confirming is capacity-gated (rejected with a 409 if it would exceed
  `capacity`); requesting itself is not — anyone can ask, the owner decides.

## Rationale

- Mirrors `going`'s proven shape end-to-end (entity, rate limits,
  before-midnight lock, self-book prevention) rather than inventing a new
  pattern — less surface area, consistent guarantees.
- Opt-in keeps ADR-0002's core guarantee intact: a walk-in *maquis* with
  `reservationsEnabled = false` (the default, and expected default for most
  venues) sees zero change. "J'y vais" remains its only signal.
- Capacity gated at confirm-time (not request-time) matches how a real host
  stand works — a request costs the venue nothing until someone commits to
  honoring it.

## Consequences

- This does **not** supersede ADR-0002 — it activates the clause ADR-0002
  itself reserved for later. Bars/*maquis* without `reservationsEnabled` are
  unaffected.
- `Venue.capacity`/`reservationsEnabled` are admin-set via the dashboard, the
  same provisioning model as every other venue field — no owner self-serve
  editing was added (the mobile `venue_management` owner-edit flow remains
  out of scope; it's mock-only pre-existing, unrelated to this feature).
- No multi-day advance booking — same-night only, so `VenueNight` stays the
  product's sole temporal spine (ADR-0001).
- No payment/deposit, and no admin-side reservation moderation screen — the
  owner is the sole approver, matching the "owner sees the texture, isn't
  required to respond" spirit of `going`, except a reservation response is
  meaningful so the owner actually acts on it.
