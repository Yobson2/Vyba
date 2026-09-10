# CLAUDE.md

Guidance for Claude Code when working in this repository. Keep this file short —
it loads on every task. Details live in `docs/` and are read on demand.

## What this is

**Vyba** — a Lagos nightlife platform: discover venues, book tables, leave
reviews, run venue promotions. Monorepo with three deployables, each bootstrapped
from a reusable starter template and adapted for Vyba:

| Path | Role | Stack |
|------|------|-------|
| `Vyba-mobile-app/` | Client + venue-owner mobile app | Flutter, Riverpod, GoRouter, Dio, Freezed |
| `Vyba-dashboard-admin/` | Platform operator dashboard | React 19, TanStack Router/Query/Table, Zustand, shadcn/ui |
| `Vyba-backend/` | REST API | NestJS 11, TypeORM + PostgreSQL, Redis, S3, Socket.IO, JWT |

Each sub-project has its own toolchain, README, and conventions. Work within the
one you're editing; don't cross-wire them.

## Architecture (high level)

- **Mobile** — Clean Architecture per feature under `lib/features/<name>/`:
  `domain` (entities, repo interfaces, use cases returning `Either<Failure, T>`),
  `data` (repo impls, datasources, Freezed models), `presentation` (pages,
  Riverpod notifiers, Freezed sealed-union states). Two role shells: **client**
  (Explore / Feed / Bookings / Profile) and **owner** (Dashboard / Bookings /
  Promos / Profile).
- **Dashboard** — feature-based under `src/features/<name>/`. Most features are a
  CRUD resource rendered as a TanStack Table with dialog-driven create/edit/delete.
  File-based routing; auth state in Zustand; server state in TanStack Query.
- **Backend** — modular NestJS under `src/modules/<name>/` on top of shared
  infrastructure in `src/common/`. JWT access + refresh tokens, role guards,
  Swagger at `/api/docs`.
- **Authorization** — the client-side `UserRole` is a UX hint only. The backend
  re-validates permissions on every request and is the source of truth.

## Non-negotiable rules

### Design (all UI, both frontends) — full detail in `docs/design-system.md`

- Dark-first. **Never** pure black `#000000` — use tonal dark surfaces.
- **No-line rule**: express boundaries through surface-tone shifts, not 1px
  borders, dividers, or outlines.
- Rounded corners only, minimum radius 8px. Shadows only from the project's
  custom shadow tokens — never default Material `elevation` or Tailwind `shadow`.
- 4px spacing grid. Use the token systems: `lib/core/theme/*` (mobile),
  `src/index.css` (dashboard).
- Brand colors are semantic: Electric Indigo `#B0A3FF` = primary/CTA · Lagos
  Emerald `#69F6B8` = success/availability only · Golden Hour `#FFB148` = promos/VIP
  only · Error `#FF6E84`.

### Security (all three projects) — full framework in `docs/security.md`

- HTTPS only, no cleartext fallback. Never commit secrets or `.env` files.
- Never log tokens, passwords, OTPs, or PII — in interceptors, or crash reports.
- Validate JWT `exp` client-side *before* using a token; don't rely on 401s.
- Mock auth is development-only: `USE_MOCK_AUTH` must default to `false` and never
  ship enabled. No hardcoded credentials in source.
- Treat a security-framework violation as blocking, exactly like a design-system
  violation. The `security-hardening-audit` skill verifies current state.

## Working in this repo

- Match the existing patterns in the sub-project before introducing new ones.
- **Mobile**: after editing any `@freezed`, `@riverpod`/`@Riverpod`, or
  `@JsonSerializable` class, run `make gen`.
- **UI work**: plan with the `ui-ux-pro-max` skill, build with `frontend-design`,
  then review with `ui-ux-pro-max`. Skip all three for trivial edits — copy,
  padding, translations, import order, non-visual bug fixes.
- **Scaffolding a feature**: use the project skills `flutter-feature-scaffold`
  (mobile) or `dashboard-crud-feature` (dashboard).

## Where the details live

| You're working on… | Read |
|--------------------|------|
| The Flutter app — commands, layer contracts, Riverpod DI graph, routing, networking, error mapping, lint | `docs/mobile.md` |
| The admin dashboard — commands, routing, state, API layer, table/dialog patterns, lint | `docs/dashboard.md` |
| The backend API — commands, module & infrastructure layout, migrations, conventions | `docs/backend.md` |
| Any UI — the full design system with rationale and edge cases | `docs/design-system.md` |
| Auth, tokens, headers, deployment hardening, CI security | `docs/security.md` |
| Mobile offline sync & conflict resolution | `Vyba-mobile-app/docs/offline_sync.md` |
| A sub-project's template origin / deep stack reference | that sub-project's `README.md` |
