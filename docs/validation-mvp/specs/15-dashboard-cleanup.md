# Spec: dashboard-cleanup

> Ready-for-agent spec. Vyba validation MVP (unit 15). **Prerequisite** for dashboard units 16–18.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §13; `VYBA_CODEBASE_AUDIT.md` §3; `Vyba-dashboard-admin/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The admin dashboard was adapted from a template and is organised around the wrong
set of features: bookings, reviews, a marketing landing page, a generic task
manager, a demo "apps" page, deep platform settings — most wired to mock data. The
validation phase needs six operational surfaces (units 16–18); building them while
the template feature set and navigation are in place is confusing and risks
inconsistent patterns.

## Solution

A removal-and-configuration pass, no new features. Unroute and de-navigate the
features the audit marks out of scope, trim settings to what the team needs, adopt
the new role vocabulary (`ADMIN` / `VENUE_OWNER` / `CLIENT`), remove self-serve
sign-up, and rebuild the sidebar around the six validation surfaces (as
placeholders where units 16–18 haven't landed yet). The app still builds and the
existing test suite is green.

## User Stories

1. As a Vyba team member, I want the sidebar to show only the surfaces we actually use, so that the tool is navigable.
2. As a developer, I want the `bookings` and `reviews` features unrouted and removed from navigation, so that they're not in the validation surface (kept in the tree for post-validation).
3. As a developer, I want the `tasks` feature and the demo `apps` route removed entirely, so that template demos aren't shipped.
4. As a developer, I want the `landing-page` feature and the `_public` marketing route unrouted, so that the dashboard is just the operator tool.
5. As a developer, I want the `audit-log` route unrouted for now, so that it's not a half-built surface.
6. As a developer, I want settings trimmed to team-member management and appearance, dropping the platform / security / notifications settings pages, so that settings isn't a template kitchen sink.
7. As a developer, I want the shared role type to be `ADMIN` / `VENUE_OWNER` / `CLIENT`, so that the dashboard speaks Vyba's actual roles.
8. As a security reviewer, I want the self-serve `sign-up` route removed, so that dashboard access can't be self-granted.
9. As a developer, I want the duplicated `data-table-*` files consolidated toward `components/ui/data-table/`, so that units 16–18 build on one shared table implementation.
10. As a developer, I want `pnpm build` (tsc + Vite) to pass and `pnpm lint` to be clean after the changes, so that the codebase stays green.
11. As a developer, I want the existing test suite to pass (tests for removed features removed), so that regressions are visible.
12. As a Vyba team member, I want sidebar placeholders for the six validation surfaces, so that the structure is visible before each is built.

## Implementation Decisions

**Remove entirely** (feature + route + tests + nav entry):

- `features/tasks`, `routes/_authenticated/tasks/`.
- `routes/_authenticated/apps/`.
- The `(auth)/sign-up` route and its feature folder.

**Unroute / de-navigate** (keep the feature folder for post-validation; remove the
route file, the sidebar entry, and any now-dead imports):

- `features/bookings`, `features/reviews`.
- `features/landing-page` and `routes/_public/`.
- `routes/_authenticated/audit-log/`.
- `features/notifications` route (broadcast tooling is post-gate; the two scheduled
  notifications are backend-driven).

**Trim**

- `features/settings`: keep `admins` (team-member accounts) and `appearance`. Remove
  the `platform`, `security`, `notifications`, and `profile` settings pages and
  their routes (or reduce `profile` to the minimum). Update `SETTINGS_NAV_ITEMS`.
- `features/users`: keep as a minimal read view (list users, see acquisition source,
  support lookup) — full CRUD is not needed. (Detailed rework can be part of unit 16
  if it grows; here just ensure it's not a blocker and not full CRUD.)

**Role vocabulary**

- Replace the template role type/strings with `ADMIN` / `VENUE_OWNER` / `CLIENT`
  wherever the dashboard references roles (auth store, guards, any role display).
  Align with backend unit 01's constant.
- Dashboard auth stays **email + password** (ADR-0003 exemption) — do not switch it
  to OTP.

**Sidebar**

- Rebuild `sidebar-data.ts` around: Provisioning (venues + owners), Content &
  curation, Monitoring & metrics, plus Settings. Where a unit (16–18) isn't built,
  the entry points to a placeholder page.

**Shared table**

- Move toward `components/ui/data-table/` for the six duplicated `data-table-*`
  pieces; units 16–18 import from there. Full de-duplication across all remaining
  features can be incremental, but the shared versions must exist and be used by new
  work.

**Do not**

- Touch the parallel Lagos→Abidjan rebrand.
- Build any of the six surfaces' real functionality (units 16–18).
- Wire the real backend API (units 16–18 do that per surface).
- Modify `docs/dashboard.md` (update when merged code actually contradicts it).

## Testing Decisions

**What a good test looks like here:** defined by absence and configuration. The
checks: `pnpm build` passes, `pnpm lint` is clean, `pnpm knip` shows no new
dead exports, and the existing test suite passes with removed-feature tests deleted.

**Seam:** the build + existing test suite. No new behavioural tests beyond adjusting
any role-type assertions and a check that the router has no unresolved routes.

**Modules under test:** none added.

**Prior art:** `docs/dashboard.md` (lint rules, `knip`, the CRUD pattern); the
existing route tree.

**Representative checks:** `pnpm build` + `pnpm lint` clean; `pnpm knip` no new
issues; the sidebar renders the validation structure; navigating to a removed route
404s via the errors feature; grep for the old role strings (`CHEF_ZONE`, `MEMBRE`)
in `src/` returns nothing; `(auth)/sign-up` is gone.

## Out of Scope

- The six operational surfaces' functionality (units 16–18).
- Any backend API wiring.
- The Lagos→Abidjan rebrand.
- A visual redesign — the dashboard stays functional-plain (MVP spec §17).
- Full de-duplication of `data-table-*` across every legacy feature (incremental).

## Further Notes

- `VYBA_CODEBASE_AUDIT.md` §3.2–3.3 is the verdict table this implements.
- Prerequisite: units 16–18 assume the trimmed navigation, the shared table, and the
  new role vocabulary.
- Dashboard auth is deliberately left on email/password (ADR-0003) — only the role
  constant changes.
