# Spec: venue-night-model

> Ready-for-agent spec. Vyba validation MVP critical path (unit 2 of 4).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §9.1, §19; `docs/adr/0001-venuenight-as-temporal-spine.md`; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

Almost everything Vyba shows about a venue is really about *that venue on a
particular night*: whether it is live right now, who is playing, tonight's promo,
how many people say they are going, photos from that night. That state is worthless
by the next morning. If it is stored as mutable fields on the venue record, the
daily reset becomes a fragile job, historical questions become impossible, and the
validation experiment cannot cleanly measure per-night activity.

The backend has no venue model at all yet (only the template's unrelated entities),
and no notion of a "night".

## Solution

Introduce two entities. **`Venue`** holds only durable facts — identity, location,
type, ownership, launch-area membership. **`VenueNight`** represents one venue on
one calendar night and owns every piece of night-scoped state. "What's happening at
this venue tonight?" is a query for today's `VenueNight`. The daily reset does not
exist — a new night is simply a new record.

Venues are created and managed by the Vyba team (admin), not self-serve. The launch
area (Zone 4 / Marcory) is a single canonical polygon in configuration that every
query and metric uses.

## User Stories

1. As the Vyba team, I want to create a venue with its name, description, address, coordinates and type, so that it can appear in the app during onboarding.
2. As the Vyba team, I want to set which venue type a venue is (club, bar, lounge, maquis), so that the product reflects the launch segment.
3. As the Vyba team, I want to bind a venue to an owner account, so that that owner can post for it.
4. As the Vyba team, I want to mark a venue's validation status (e.g. onboarding, active, paused), so that only ready venues are shown to users.
5. As the Vyba team, I want a venue's launch-area membership derived from its coordinates against the canonical Zone 4 polygon, so that "in Zone 4" is consistent everywhere.
6. As the Vyba team, I want to update a venue's profile and photos, so that I can keep it correct without the owner having to.
7. As a client, I want to see the list of active venues in Zone 4, so that I can browse where to go.
8. As a client, I want to open a venue and see its durable profile plus tonight's state (live or not, tonight's headline, going count), so that I can decide in one view.
9. As a client, I want a venue that is not live and has no activity tonight to still show its profile, so that I can see it exists and what it is.
10. As a venue owner, I want one tap to mark my venue live for tonight, so that it takes seconds.
11. As a venue owner, I want to set tonight's headline / DJ, so that people know what is on.
12. As a venue owner, I want marking live again later the same night to be idempotent, so that I do not create duplicate state.
13. As a venue owner, I want tonight's state to not carry over to tomorrow automatically, so that a stale "live" flag never misleads anyone.
14. As a developer, I want a get-or-create for "this venue tonight", so that `going`, `feed` and `promotions` can attach to a `VenueNight` without racing.
15. As a developer, I want the `VenueNight` to expose its aggregate going count, so that feed ranking and the venue view can read it cheaply.
16. As a developer, I want a `(venue, date)` uniqueness guarantee on `VenueNight`, so that there is exactly one record per venue per night.
17. As a platform operator, I want per-night engagement rollups (views, going, posts) stored on or derivable from the `VenueNight`, so that the validation metrics can be computed per night.
18. As a reviewer, I want it to be structurally impossible to add `is_live` / `going_count` / `live_since` to `Venue`, so that ADR-0001 is not quietly violated later.
19. As the Vyba team, I want the "night" boundary defined in Abidjan local time, so that a night that runs past midnight is still "one night".
20. As a client, I want the venue list filterable by venue type, so that a small filter replaces a search box.

## Implementation Decisions

**Modules**

- New `venues` module — `Venue` entity + admin CRUD + public read endpoints.
- New `venue-nights` module — `VenueNight` entity + get-or-create + owner
  live/headline endpoints + read endpoints. May live alongside `venues`; keep the
  aggregate boundary clear (nothing else writes night state).
- Shared config — the Zone 4 / Marcory polygon (GeoJSON or a bounding polygon) as a
  single configuration value, plus a `pointInLaunchArea(lat, lng)` helper.

**`Venue` entity (durable only)**

- Identity: id, name, description, address, latitude, longitude.
- Classification: `venueType` ∈ { club, bar, lounge, maquis }, `priceLevel` (1–4).
- Media: hero photos (ordered list of stored image refs; upload handled by the
  `media` unit — store refs here).
- Ownership: `ownerUserId` (nullable until bound).
- Status: `validationStatus` ∈ { onboarding, active, paused } (name TBD by
  implementer, meaning fixed). Only `active` venues are returned to clients.
- Derived: `inLaunchArea` (computed from coordinates; stored or computed
  consistently — if stored, recompute on coordinate change).
- Extends `BaseEntity` (soft-delete via `isActive`), per `docs/backend.md`.
- **No night-scoped fields.**

**`VenueNight` entity**

- Key: `venueId` + `date` (calendar date in Abidjan local time), unique together.
- Live: `isLive` (bool), `liveSince` (timestamp, set when first toggled on),
  `liveSetBy` (userId).
- Headline: `headline` (text, nullable), optional `djName`.
- Aggregates: `goingCount` (maintained by the `going` unit — denormalised counter
  updated transactionally, or a computed read; implementer's call, but reads must
  be cheap), and room for per-night rollups (`viewCount`, `postCount`) added by the
  units that own those events.
- Lifecycle: created lazily via get-or-create on the first write for that
  `(venue, date)` — a live toggle, a going mark, or a promo. No cron creates them.
- No "reset": yesterday's `VenueNight` simply is not today's. Reads for "tonight"
  filter on `date = today (Abidjan)`.

**Night boundary**

- A "night" is a calendar date in Africa/Abidjan (UTC+0). Activity at 01:00 counts
  as the previous calendar date is **not** done for v1 — keep it simple: the night
  is the local calendar date. (If real usage shows 00:00–04:00 activity being
  misfiled, revisit; noted in Further Notes.)

**Endpoints (shape, not paths)**

- Admin: create / update / list / get venue; bind owner; set status; upload/reorder
  photos (delegates to `media`).
- Owner: set-live (idempotent on/off) for tonight; set tonight's headline. Guarded
  by `@Roles(VENUE_OWNER)` + an ownership check (principal `userId` ==
  `venue.ownerUserId`).
- Public: list active venues in the launch area (filter by `venueType`); get venue
  detail = durable profile + today's `VenueNight` (or a "no activity tonight"
  shape).
- Internal: `getOrCreateVenueNight(venueId, date)` for other modules.

**Authorization**

- All venue writes are `ADMIN` except the two owner endpoints.
- Two read paths:
  - **Authenticated** (any `CLIENT`) — the app's read path. Full public venue
    payload.
  - **Unauthenticated public read** — a separate, read-only, rate-limited endpoint
    for the QR web surface (venue detail + today's `VenueNight`). Exposes only
    explicitly public, PII-free fields; no follower identities, no "who's going"
    list, no owner data. No mutations on this path. It must not widen what the
    authenticated path already exposes, and must not weaken any existing
    authorization. Abuse-monitored.
- The QR flow is: QR scan → public venue read → public Zone 4 feed → "J'y vais" →
  phone → OTP → authenticated session → Going. No anonymous device identity/token
  is introduced unless a later concrete requirement demands one.

**Migration / template cleanup**

- The template's role/family entities are not touched here beyond what unit 1 does.
- The dashboard `venues` feature and mobile `venues` entity are updated in their own
  units; this unit only owns the backend contract. Naira and `rooftop`/`beachClub`
  are not part of this contract.

## Testing Decisions

**Good test:** drives the HTTP API of the booted app and asserts what a client or
the team would observe — a created venue appears in the Zone 4 list only when
active; a venue outside the polygon never appears; toggling live twice yields one
`VenueNight` with `isLive = true`; tonight's state is absent when queried "tomorrow".
Never asserts on the counter column directly or on get-or-create internals.

**Seam:** backend HTTP API — the e2e seam established by unit 1 (`supertest`, booted
app, throwaway Postgres). Reuse unit 1's auth helper to obtain `ADMIN`,
`VENUE_OWNER` and `CLIENT` tokens.

**Modules under test:** `venues` and `venue-nights` through the API.

**Prior art:** unit 1's e2e spec; module conventions in `docs/backend.md`
(controller `@Api*` decorators, typed exceptions, `PaginatedResponseDto` for lists).

**Representative cases:** admin creates venue → not in client list until `active`;
venue with out-of-area coordinates → `inLaunchArea = false`, excluded from Zone 4
list; owner sets live → venue detail shows live + `liveSince`; a different owner
cannot set live on someone else's venue (403); get venue detail with no activity →
profile + empty-night shape; second `getOrCreateVenueNight` same day → same id;
list filtered by `venueType`.

## Out of Scope

- Structured opening hours / "open now" — deliberately replaced by the live signal
  (MVP spec §8.2).
- Real booking / table inventory.
- The `going` mark/count write logic (unit 4) — this unit only exposes the
  aggregate field and get-or-create.
- Feed items (unit 3).
- Photo upload/curation mechanics (media unit) — this unit stores refs.
- Dashboard provisioning UI and mobile venue screens (their own units).
- Multi-commune / expansion — one polygon only.

## Further Notes

- ADR-0001 is the rationale; the "no night state on Venue" rule is an invariant in
  `Vyba-backend/CONTEXT.md`.
- Lazy creation trigger and whether `goingCount` is a maintained counter or a
  computed read are left to the implementer, but both reads ("tonight for a venue",
  "list with counts") must be cheap enough for the feed ranking endpoint to call
  per request.
- The 00:00–04:00 "which night?" question is explicitly deferred; revisit only if
  data shows misfiling.
