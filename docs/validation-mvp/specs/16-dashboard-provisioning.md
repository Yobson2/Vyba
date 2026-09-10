# Spec: dashboard-provisioning

> Ready-for-agent spec. Vyba validation MVP critical path (unit 16). Depends on 15, and backend 01, 02, 06.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §7, §13 (surface 1); `docs/adr/0001`, `docs/adr/0003`; `Vyba-dashboard-admin/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

Venues and venue-owner accounts are created by the Vyba team in person during
onboarding — there is no self-serve. The team needs one dashboard surface to: create
a venue with its location and type, upload its first photos, create the owner's
account (by phone number) and bind it to the venue, and move the venue through its
validation status so only ready venues show to users. Without this, nothing gets
into the system.

## Solution

A provisioning surface in the dashboard: a venues table (the house CRUD pattern)
with create/edit, an owner-account creation-and-binding flow, photo upload for the
venue, and a status control. Built on the shared `data-table` components and the
backend `venues` / `auth` / `media` contracts.

## User Stories

1. As a Vyba team member, I want to create a venue with name, description, address, coordinates, type and price level, so that it exists in the system.
2. As a team member, I want to set coordinates by entering them or picking on a small map, so that the venue's Zone 4 membership is derived correctly.
3. As a team member, I want to see whether a venue's coordinates fall inside the Zone 4 polygon, so that I know it'll appear in the launch-area feed.
4. As a team member, I want to upload a venue's first photos, so that its profile isn't empty on day one.
5. As a team member, I want to create an owner account by entering the manager's phone number and name, so that onboarding produces a working login.
6. As a team member, I want to bind that owner account to the venue, so that they can post for it.
7. As a team member, I want to re-bind or unbind an owner if a venue changes hands, so that access stays correct.
8. As a team member, I want to set a venue's status (onboarding / active / paused), so that only ready venues are shown to users.
9. As a team member, I want a venues table I can sort and filter (by status, type, owner-bound or not), so that I can manage ~30 venues easily.
10. As a team member, I want to edit a venue's profile later, so that I can keep it correct without the owner.
11. As a team member, I want the starter-content checklist state visible per venue (has photos, has first post, owner trained), so that I can track onboarding completeness.
12. As a security reviewer, I want venue and owner-account creation restricted to `ADMIN`, so that provisioning can't be done by a lesser role.
13. As a developer, I want the surface built on the shared `data-table` and dialog pattern, so that it's consistent with the rest of the dashboard.
14. As a platform operator, I want each provisioned owner account and venue timestamped and attributed to the team member who created it, so that onboarding activity is auditable.

## Implementation Decisions

**Feature**

- Repurpose `features/venues` into the provisioning surface (the audit's plan). Use
  the shared `data-table` components (from unit 15), the dialog-driven
  create/edit/delete pattern, a Zod schema matching the backend `Venue`, and
  TanStack Query against the real API.

**Venue create/edit dialog**

- Fields: name, description, address, latitude/longitude (numeric inputs +
  optionally a small Leaflet/Google static-map picker — a plain lat/lng input is
  acceptable for v1), `venueType` ∈ { club, bar, lounge, maquis }, `priceLevel`
  (1–4).
- On save, the backend derives launch-area membership; the UI shows the resulting
  `inLaunchArea` badge.
- Photo upload: multi-file, calls the backend `media` upload (context
  `venue_profile`); shows thumbnails; reorder.

**Owner account + binding**

- From a venue row: "créer / lier un compte propriétaire". Input: phone (E.164),
  name. Calls the backend owner-provisioning endpoint (unit 01) → creates a
  `VENUE_OWNER` user bound to the venue.
- Show the bound owner on the venue row; allow unbind / re-bind.
- No password is set — the owner signs in with phone + OTP (ADR-0003).

**Status**

- A control on the row / in the edit dialog: `onboarding` → `active` → `paused` (and
  back). Only `active` venues reach users (enforced backend-side; the UI just sets
  it).

**Onboarding checklist (lightweight)**

- Per venue, derived indicators: has ≥3 photos, has ≥1 `origin = venue` post,
  owner bound. A simple checklist column/panel — data from existing endpoints, no
  new backend needed beyond counts. (If a count endpoint is missing, it's a small
  add to backend unit 02/03; note it.)

**Authorization**

- Every action requires `ADMIN` (dashboard role). The dashboard auth store already
  carries the role (unit 15).

**Analytics**

- Not required from the dashboard for this surface beyond what the backend records
  (creator + timestamp).

## Testing Decisions

**Good test:** React Testing Library + **MSW** at the page level. Render the venues
table against a mocked API and assert: creating a venue posts the right payload and
the row appears; an out-of-area lat/lng shows the "hors zone" badge from the mocked
response; the owner-binding dialog posts phone + name and the row then shows the
bound owner; changing status posts the new status; the surface is gated so a
non-`ADMIN` mocked session can't see the actions.

**Seam:** the dashboard **page integration layer with MSW**. No component-internal
tests; assert on what the team member sees and the requests made.

**Modules under test:** the provisioning feature page + dialogs.

**Prior art:** the existing `features/venues` CRUD scaffold and `features/users`
dialogs; `docs/dashboard.md` table/dialog patterns; the shared `data-table`.

**Representative cases:** create venue → POST venue, row added; edit → PATCH; upload
photo → media POST, thumbnail shown; create+bind owner → POST owner, row shows
owner; unbind → row shows unbound; set status active → PATCH status; filter table by
status = onboarding; checklist shows "photos ✓ / premier post ✗ / propriétaire ✓".

## Out of Scope

- Self-serve venue claiming or owner sign-up (does not exist — ADR-0003).
- Editorial, assist-mode posting, photo curation (unit 17).
- The VenueNight monitor and metrics (unit 18).
- The map-picker being a full interactive map — lat/lng inputs are acceptable for
  v1.
- Owner-side venue editing (owners don't edit their profile during validation —
  MVP spec §10).
- Bulk import of venues.

## Further Notes

- ADR-0003: owner accounts are phone-first and team-provisioned; no password field.
- ADR-0001: coordinates drive launch-area membership; the same polygon as backend
  unit 02.
- The onboarding checklist supports the ops process in MVP spec §22.1 — keep it
  lightweight (derived indicators, not a workflow engine).
