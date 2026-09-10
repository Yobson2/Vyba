# Spec: dashboard-content-and-curation

> Ready-for-agent spec. Vyba validation MVP (unit 17) — supports the "organic posting" gate by keeping the team's assist path attributed. Depends on 15, 16, and backend 03, 06.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §13 (surfaces 2–4), §13.1, §9.2; `Vyba-dashboard-admin/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

During validation the Vyba team keeps the feed alive: publishing daily editorial,
creating content on behalf of venues that haven't posted yet, and promoting good
user photos into the feed. All of this must go through paths that correctly record
whether the team was involved (`assisted`), because "organic vs assisted posting" is
the central validation metric. The dashboard has no editorial composer, no assist
mode, and no curation queue.

## Solution

One dashboard surface for team-managed feed content, three closely-coupled parts:
an **editorial composer** (team-authored `editorial` feed items with publish/expiry),
an **assist mode** (create a promo / update / live post *for* a venue, backend-stamped
`assisted = true`), and a **photo curation queue** (review user-submitted VenueNight
photos → promote / hide / delete). All on one seam, all against the backend `feed`
and `media` contracts.

## User Stories

1. As a Vyba team member, I want to write an editorial item ("Ce soir à Zone 4", "5 spots chauds ce soir") with a title and body, so that the feed has content on quiet nights.
2. As a team member, I want to set an editorial item's publish time and expiry, so that it appears when relevant and disappears when stale.
3. As a team member, I want to save an editorial item as a draft, so that I can prepare it earlier.
4. As a team member, I want to associate an editorial item with the area or a specific venue, so that it's placed correctly.
5. As a team member, I want to create a promotion, a venue update, or a "live tonight" post on behalf of a venue, so that a venue that hasn't posted yet still has presence.
6. As a team member, I want anything I create for a venue automatically recorded as founder-assisted, so that the organic-vs-assisted metric is accurate without me having to remember a flag.
7. As a team member, I want to see, per venue, how much of its recent content was assisted vs organic, so that I know which venues to nudge toward posting themselves.
8. As a team member, I want a queue of user-submitted photos with the venue, the night, and who uploaded, so that I can review them in the daily pass.
9. As a team member, I want to promote a good user photo into the feed, so that the feed has a human pulse.
10. As a team member, I want to hide or delete a bad photo quickly, so that feed quality holds.
11. As a team member, I want to hide or remove any feed item, so that bad content can be pulled.
12. As a team member, I want the composer and assist forms to be fast, so that the daily content pass doesn't take long.
13. As a security reviewer, I want assist-mode and editorial restricted to `ADMIN`, and the `assisted` flag set by the backend not the form, so that provenance can't be forged.
14. As a platform operator, I want assisted and organic post counts per venue per week available, so that the validation gate is measurable.
15. As a developer, I want this built on the shared dashboard patterns, so that it's consistent.

## Implementation Decisions

**Feature**

- One dashboard feature (e.g. `features/content`) with three views/tabs: Editorial,
  Assist, Curation. Shared `data-table` for the list views; React Hook Form + Zod
  for the composers; TanStack Query against the backend `feed` and `media` APIs.

**Editorial composer**

- Form: title, body (plain text / minimal formatting), association (area-wide or a
  venue), `publishedAt` (now or scheduled), `expiresAt` (default: a sensible window,
  editable), draft/published toggle.
- Calls the backend `feed` editorial-create endpoint → `origin = founder`,
  `assisted = false`.
- A list of editorial items with status (draft / published / expired) and quick
  edit / unpublish.

**Assist mode**

- Pick a venue → choose a content type (promo / venue_update / live_tonight) → a
  form matching that type's payload → publish.
- Calls the backend `feed` assist endpoint (the one that stamps `origin =
  founder_assisted`, `assisted = true`, `createdBy = the team member`). The form has
  **no** origin/assisted control.
- A per-venue mini-panel: "cette semaine — X posts (Y assistés, Z organiques)" from
  the backend (unit 07 / feed queries).

**Photo curation queue**

- List `venue_night_user` photos by status / venue / date (backend `media` unit 06).
- Actions: promote (→ creates a `photo` feed item), hide, hard-delete. Show the
  uploader and upload time (audit).
- After promote, the item shows as promoted; hide/delete removes it from feed and
  night view.

**Feed moderation**

- A general "hide / delete" action reachable from any content list (editorial,
  assisted, promoted photos) — calls the backend `feed` moderation endpoints.

**Authorization**

- All actions `ADMIN`.

## Testing Decisions

**Good test:** RTL + **MSW** at the page level. Assert: submitting the editorial
composer posts the right payload and the item appears in the editorial list with the
chosen status; the assist form for "promo on venue V" posts to the assist endpoint
(and the test asserts the request went to the assist path, since `assisted` is the
backend's job — the form must not send it); the per-venue panel renders the
assisted/organic counts from the mocked response; promoting a queued photo calls the
media promote endpoint and the row updates; hiding a feed item calls the moderation
endpoint.

**Seam:** the dashboard **page integration layer with MSW**.

**Modules under test:** the content feature's three views.

**Prior art:** `features/promotions` (assist form starting point), the CRUD/dialog
pattern in `docs/dashboard.md`, the shared `data-table`.

**Representative cases:** create editorial (scheduled) → POST, listed as "planifié";
publish now → listed as "publié"; assist-create promo for V1 → POST to assist
endpoint, no `assisted` field in the body; per-venue panel shows "3 posts (2
assistés, 1 organique)"; curation queue lists a photo with uploader → promote →
media promote POST, row shows "mis en avant"; hide a feed item → moderation POST,
item marked hidden.

## Out of Scope

- Venue/owner provisioning (unit 16).
- The VenueNight monitor and validation metrics dashboard (unit 18) — this unit's
  per-venue mini-panel is a nudging aid, not the metrics surface.
- A rich text editor / media library / CMS.
- Automated content moderation.
- The backend enforcement of `assisted` (unit 03) — this unit must simply not
  send it and must use the assist endpoint.
- Owner-side posting (mobile unit 13).

## Further Notes

- MVP spec §9.2 / §13.1: `assisted` is enforced server-side; this surface's job is
  to always route team-for-venue content through the assist endpoint and never
  expose an origin control.
- The three parts are merged into one unit because they share a seam, a role, and
  the "team manages feed content" purpose — splitting them would be micro-specs
  (per the normalization pass).
- Editorial formats and cadence are operational (MVP spec §22.2); this unit provides
  the tool, not the schedule.
