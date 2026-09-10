# CLAUDE.md

Entry point for Claude Code — global instructions and navigation only. Concepts
live in `CONTEXT.md`, mechanics in `docs/`, read on demand.

## What this is

**Vyba** — a nightlife discovery and coordination platform for Abidjan, Côte
d'Ivoire: discover venues, see what's happening tonight, signal intent to go out
("J'y vais"), leave reviews, run venue promotions. In a **validation phase** scoped
to one commune (Zone 4 / Marcory).

Monorepo, three deployables, each adapted from a starter template. Each has its own
toolchain, README and conventions — work within the one you're editing, don't
cross-wire them.

| Path | Role | Stack |
|------|------|-------|
| `Vyba-mobile-app/` | Client + venue-owner mobile app | Flutter, Riverpod, GoRouter, Dio, Freezed |
| `Vyba-dashboard-admin/` | Vyba team operations dashboard | React 19, TanStack Router/Query/Table, Zustand, shadcn/ui |
| `Vyba-backend/` | REST API | NestJS 11, TypeORM + PostgreSQL, Redis, S3, Socket.IO, JWT |

## Start here

- **Product & domain vocabulary** — `CONTEXT.md`, then the relevant sub-project `CONTEXT.md`.
- **Decisions & rationale** — `docs/adr/`.
- **Current build target** — `docs/validation-mvp/`.

## Architecture (high level)

- **Mobile** — Clean Architecture per feature (`domain` / `data` / `presentation`);
  use cases return `Either<Failure, T>`; state is a Freezed sealed union. Client
  and owner role shells.
- **Dashboard** — feature-based; most features are a CRUD resource as a TanStack
  Table with dialog-driven create/edit/delete.
- **Backend** — modular NestJS (`src/modules/<name>/`) on shared `src/common/`
  infrastructure. JWT access + refresh, role guards, Swagger at `/api/docs`.
- **Authorization** — the client-side `UserRole` is a UX hint only; the backend
  re-validates on every request and is the source of truth.

## Non-negotiable rules

### Design (all UI, both frontends) — full detail in `docs/design-system.md`

- Dark-first. **Never** pure black `#000000` — use tonal dark surfaces.
- **No-line rule**: express boundaries through surface-tone shifts, not 1px
  borders, dividers, or outlines.
- Rounded corners only, minimum radius 8px. Shadows only from the project's
  custom shadow tokens — never default Material `elevation` or Tailwind `shadow`.
- 4px spacing grid. Use the token systems: `lib/core/theme/*` (mobile),
  `src/index.css` (dashboard).
- Brand colors are semantic: Electric Indigo `#B0A3FF` = primary/CTA · Abidjan
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

- Match existing patterns in the sub-project before introducing new ones.
- **Mobile**: run `make gen` after editing any `@freezed`, `@riverpod`/`@Riverpod`
  or `@JsonSerializable` class.
- **UI work**: plan with `ui-ux-pro-max`, build with `frontend-design`, review with
  `ui-ux-pro-max`. Skip for trivial edits (copy, padding, translations, import
  order, non-visual fixes).
- **Scaffolding a feature**: use `flutter-feature-scaffold` (mobile) or
  `dashboard-crud-feature` (dashboard).

## Where the details live

| Topic | Read |
|---|---|
| Product concepts, glossary, actors, invariants | `CONTEXT.md` + sub-project `CONTEXT.md` |
| The validation MVP — spec, scope, codebase audit | `docs/validation-mvp/` |
| Flutter app — commands, layer contracts, DI graph, routing, networking, lint | `docs/mobile.md` |
| Admin dashboard — commands, routing, state, API layer, table/dialog patterns | `docs/dashboard.md` |
| Backend API — commands, module & infrastructure layout, migrations, conventions | `docs/backend.md` |
| Full design system — rationale and edge cases | `docs/design-system.md` |
| Auth, tokens, headers, deployment hardening, CI security | `docs/security.md` |
| Mobile offline sync & conflict resolution | `Vyba-mobile-app/docs/offline_sync.md` |
| A sub-project's template origin / deep stack reference | that sub-project's `README.md` |

## Agent skills

### Issue tracker

GitHub Issues on `Yobson2/Vyba` via the `gh` CLI (pending `gh auth login`). See
`docs/agents/issue-tracker.md`.

### Domain docs

Multi-context: root `CONTEXT.md` + one `CONTEXT.md` per sub-project + `docs/adr/`.
See `docs/agents/domain.md`.
