# ADR-0005: Venue discovery is not geofenced to Zone 4

## Status

Accepted (2026-09-12)

## Context

The validation MVP was scoped to a single commune — Zone 4 / Marcory — per
`VYBA_VALIDATION_MVP_SPEC.md` §2: "one high-density nightlife zone... not all
of Abidjan." That decision was implemented as a hard backend gate:
`pointInLaunchArea` (`launch-area.config.ts`) computes `Venue.inLaunchArea`,
and `VenuesService.findEligibleByIds()` excluded any venue with
`inLaunchArea = false` from the feed. There was also no client-facing venue
*search* at all — `VenuesController` is entirely admin CRUD, and the mobile
app's `VenueRemoteDataSourceImpl.getVenues`/`searchVenues` were
`UnimplementedError` stubs (Explore ran on mock data only).

Product direction changed: users should be able to discover **any venue a
venue owner has registered**, anywhere, not just inside the original pilot
commune — plus search by name and search by proximity to their live
location ("nearby").

## Decision

- Venue discovery (the feed, and a new venue search surface) is no longer
  geofenced. `findEligibleByIds()` now only requires a venue to be
  `isActive` and `validationStatus = ACTIVE` — location plays no part in
  whether it's discoverable.
- A new public discovery endpoint, `GET /api/discover/venues`, supports an
  optional free-text `query` (name/address) and, when the caller supplies
  `lat`/`lng`, sorts results by distance (optionally capped by `radiusKm`).
- The mobile Explore tab is wired to this endpoint (previously mock-only),
  with a "Nearby" action that requests the device's location and re-sorts by
  distance.
- `inLaunchArea` and `pointInLaunchArea` are **not removed** — they keep
  labeling analytics (`acquisition_zone`/`active_zone` as `zone_4` vs
  `other`, per spec §11) so the original pilot commune's performance stays
  measurable even though it no longer gates visibility.

## Rationale

- Discovery gated by a hardcoded polygon didn't scale past the pilot and
  actively fought the "any registered venue is legitimate inventory" model
  the product is moving to.
- The single-zone framing in `VYBA_VALIDATION_MVP_SPEC.md` §2 was a
  validation-phase constraint, not a permanent architectural one — nothing
  about `VenueNight`, `Going`, `Follow`, or the feed's ranking model depends
  on geography.
- Keeping the analytics label (rather than deleting `inLaunchArea` outright)
  preserves the ability to compare pilot-zone engagement against the wider
  rollout, which the validation gates in spec §23 were built around.

## Consequences

- `VYBA_VALIDATION_MVP_SPEC.md` §2's single-zone launch scope is superseded
  by this ADR on the discovery-visibility point; the document itself is left
  as a historical record of the original validation plan rather than
  rewritten.
- `CONTEXT.md`'s "Launch area" bullet and "Client" actor description are
  updated to describe discovery-anywhere + nearby search.
- Venue *creation* is untouched — still admin/team-provisioned only, no
  self-serve claiming.
- The dashboard's `inLaunchArea` badge and Vyba-web's `/zone4` route keep
  their current meaning (pilot-zone membership) rather than being
  reinterpreted as a visibility flag.
