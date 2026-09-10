# Vyba Admin Dashboard — Domain Context

Domain boundaries for the React admin dashboard. For commands, routing, state, the
API layer and the table/dialog patterns, read `../docs/dashboard.md`. For product
vocabulary, read `../CONTEXT.md`. Code is the source of truth for implementation
detail.

## Role

The **Vyba team's internal operational cockpit** — not a customer product, not a
venue-owner product. During the validation phase it is where the founding team runs
the high-touch work that keeps the marketplace alive.

## What it is for (validation phase)

Six operational surfaces:

1. **Venue + owner provisioning** — create a venue, provision and bind an owner
   account, set coordinates, upload initial content, manage validation status.
2. **Editorial composer** — author `editorial` feed items with publish/expiry.
3. **Assist mode** — create venue content (promo / update / live) *on behalf of* a
   venue; the backend stamps it `assisted = true` with the real creator.
4. **Photo curation queue** — review user-submitted VenueNight photos and
   promote / hide / delete.
5. **VenueNight monitor** — tonight's venues at a glance: live status, going
   counts, where to intervene.
6. **Validation metrics** — the gate metrics (Zone 4 WAU, week-4 retention,
   organic vs assisted posting, going activity) from first-party data, with links
   into PostHog.

## Invariants

1. **Team-only tool.** Access is Vyba staff; there is no self-serve sign-up.
2. **Content trust split.** Venue content (from provisioned accounts) publishes
   immediately; user content is curated before it reaches the main feed.
3. **Assist actions are attributed.** Creating content for a venue always goes
   through the path that records `assisted` — never a way to post as a venue
   silently. (See ADR-0001-adjacent notes and the spec.)
4. **House style: the CRUD-resource pattern.** Most surfaces are a schema + table +
   dialog-driven create/edit/delete. Reuse the shared `data-table` pieces rather
   than copying them per feature.

## Out of scope for validation

Booking management, reviews management, the marketing landing page, generic task
management, deep platform settings, and boost/billing tooling. Several exist as
template scaffolding and are left unrouted — see
`../docs/validation-mvp/VYBA_CODEBASE_AUDIT.md`.

## Template origin

Bootstrapped from a React admin template; much of the current feature set is
template scaffolding wired to mock data. `../CONTEXT.md`, the ADRs and the audit
are authoritative over what the dashboard should actually be.
