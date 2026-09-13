# Architecture Decision Records

Each ADR records one significant decision: the context that forced it, what was
decided, why, and the consequences. ADRs are about **decisions and rationale**, not
implementation — code and `docs/` hold the how.

## Index

| # | Title | Status |
|---|---|---|
| [0001](0001-venuenight-as-temporal-spine.md) | VenueNight as the temporal spine | Accepted |
| [0002](0002-soft-jy-vais-intent-instead-of-reservations.md) | Soft "J'y vais" intent instead of reservations | Accepted |
| [0003](0003-phone-otp-as-sole-identity.md) | Phone-OTP as the sole identity primitive | Accepted |
| [0004](0004-separate-lightweight-web-surface.md) | A separate lightweight web surface, not Flutter web | Accepted |
| [0005](0005-venue-discovery-not-geofenced.md) | Venue discovery is not geofenced to Zone 4 | Accepted |

## Adding an ADR

1. Copy the shape of an existing one: **Status · Context · Decision · Rationale ·
   Consequences**.
2. Number it sequentially; keep the filename kebab-case.
3. Add a row to the index above.
4. Status is one of: Proposed, Accepted, Superseded by ADR-XXXX, Deprecated.
5. Don't edit an accepted ADR's decision after the fact — supersede it with a new
   one and update both statuses.

Scope: these ADRs are project-wide. If a decision only affects one sub-project and
needs its own history, a `Vyba-<project>/docs/adr/` directory can be added later.
