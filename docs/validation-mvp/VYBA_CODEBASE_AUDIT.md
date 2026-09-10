# Vyba — Codebase Audit vs Validation MVP Spec

**Date:** 2026-09-10 · Companion to `VYBA_VALIDATION_MVP_SPEC.md` · **Review before implementing.**

Verdict legend:

| Verb | Meaning |
|---|---|
| **EXISTS** | Usable as-is (or near-as-is) for the validation build |
| **MODIFY** | Keep the scaffold, change it to match the spec |
| **BUILD** | Net-new — does not exist |
| **DELETE** | Remove from the codebase now (dead weight / contradicts the spec) |
| **DEFER** | Leave scaffolded and untouched; not in the validation build; revisit post-gate |

---

## 0. Headline findings

1. **The backend is not started.** `Vyba-backend/` is still the raw NestJS template — its
   domain is a *family/zone/genealogy* app (`UserRole.CHEF_ZONE` = "Manages families and
   members within their assigned zone", `MEMBRE` = "own family data"). Auth is
   **email + password**, not phone + OTP. Zero Vyba domain modules exist. §19 of the spec is
   almost entirely **BUILD**.
2. **The mobile app is the furthest along** — Vyba-specific screens, `VenueType.maquis`,
   phone-auth pages, OTP page, role shells — but it is **mock-only** for everything except
   `auth` and `venues` (no real remote datasources), still **email-first**, still prices in
   **Naira (`₦`)**, and carries a large amount of out-of-scope scaffolding.
3. **The dashboard is CRUD-scaffold-rich but wired to mock data** and organized around the
   wrong six features. None of the six §13 cockpit surfaces exist in usable form; several
   need to be built from the CRUD pattern.
4. **No `VenueNight` concept anywhere.** It is the spec's temporal spine (§9.1) and is
   100% BUILD across all three projects.
5. **No analytics/attribution infrastructure.** PostHog, the event taxonomy, the
   `assisted` flag, the attribution params, the server proxy — all BUILD.
6. **The QR / mobile-web surface does not exist as a project.** BUILD from zero.
7. **Localization is bilingual EN/FR** in both frontends — spec is **French-only** (§2).

---

## 1. Vyba-backend/

### 1.1 Infrastructure (`src/common/`) — mostly keep

| Component | State | Verdict | Action |
|---|---|---|---|
| `common/config` (Docker-aware env loader, TypeORM config, `BaseEntity`) | Template, generic | **EXISTS** | Keep. Add Vyba env groups (SMS, PostHog, S3 buckets, Zone 4 polygon). |
| `common/database` + `BaseEntity` (soft-delete `isActive`) | Generic | **EXISTS** | Keep. |
| `common/redis` (ioredis) | Generic | **EXISTS** | Keep — needed for OTP rate-limiting + sessions. |
| `common/storage` (S3-compatible) | Generic | **EXISTS** | Keep — venue/user photos (§19 `media`). |
| `common/websockets` (Socket.IO + Redis bridge) | Generic | **DEFER** | Not used in v1 (going count is poll-on-view, §9.3). Leave; do not wire. |
| `common/queues` (BullMQ) | Generic | **EXISTS** | Keep — scheduled notifications (§12), photo processing. |
| `common/firebase` (Admin / push) | Generic | **EXISTS** | Keep — FCM (§12, §14.3). |
| `common/mail` (Nodemailer + Handlebars) | Generic | **DEFER** | No transactional email in v1 (phone-only). Leave, don't use. |
| `common/guards` (`auth.guard`, `roles.guard`), `decorators` (`@GetUser`, `@Roles`, `@Public`) | Generic | **MODIFY** | Keep the mechanism; re-point at the new role set (§1.2). |
| `common/dto` (pagination), `filters` (global exception), `exceptions` (typed domain errors) | Generic | **EXISTS** | Keep; add per-module exceptions following the pattern. |
| `common/middleware` (JWT auth) | Generic | **MODIFY** | Adapt to phone-OTP session/JWT flow. |

### 1.2 `modules/auth` — rework

| Component | State | Verdict | Action |
|---|---|---|---|
| `auth.service` | **Email + password** register/login/refresh, `bcrypt`, `findByEmail` | **MODIFY** (large) | Replace with: request-OTP (phone) → verify-OTP → issue JWT access + refresh. Keep `generateTokens` + refresh logic. Drop `bcrypt`/password path. |
| `dto/login.dto`, `dto/register.dto` | email/password shapes | **MODIFY** | → `RequestOtpDto { phone }`, `VerifyOtpDto { phone, code }`. |
| `dto/refresh-token.dto` | generic | **EXISTS** | Keep. |
| OTP issuance/storage/rate-limit | — | **BUILD** | Redis-backed code store, expiry, attempt limits, resend cooldown, duplicate-code handling (§20.2). |
| SMS provider integration | — | **BUILD** | Africa-focused provider abstraction + WhatsApp fallback interface (§14.1). |

### 1.3 `modules/users` — modify

| Component | State | Verdict | Action |
|---|---|---|---|
| `entities/user.entity` | `email` (unique, required), `password`, `firstName`, `lastName`, role enum | **MODIFY** | `phone` (unique, required, E.164), drop `password`, keep name fields optional, add `acquisition_*` snapshot fields + `active_zone`, `age_confirmed_at`. |
| `users.service` (`findByEmail`, `create` w/ bcrypt) | template | **MODIFY** | `findByPhone`, create-from-verified-phone, no password hashing. |
| `users.controller` + spec | reference CRUD | **MODIFY** | Trim to what admin provisioning + profile need. |
| `common/constants/roles.constant` | `ADMIN` / `CHEF_ZONE` / `MEMBRE` ("families", "zones") — **wrong domain** | **MODIFY** | → `ADMIN` (team), `VENUE_OWNER`, `CLIENT`. Fix `ROLE_METADATA` copy. |

### 1.4 `modules/health` | template | **EXISTS** | Keep.

### 1.5 New backend modules (§19) — all BUILD

| Module | Verdict | Notes |
|---|---|---|
| `venues` | **BUILD** | Team-managed CRUD, geo coords, Zone 4 boundary config, `active_zone` tagging source. |
| `venue-nights` | **BUILD** | `VenueNight (venue, date)` — live status + `live_since`, headline/DJ, per-night aggregates. The temporal spine (§9.1). |
| `feed` | **BUILD** | Polymorphic `FeedItem` + type enum (§3.2), server-side ranking endpoint (§3.3), `starts_at`/`expires_at` + expiry job, `created_by` + `assisted` + origin (§9.2). |
| `going` | **BUILD** | mark/cancel (1/user/venue/night, editable until midnight), per-venue-night aggregate, daily reset/decay, owner-cannot-inflate, abuse protection, feeds the ranking signal. |
| `follows` | **BUILD** | user↔venue. |
| `promotions` | **BUILD** | promo CRUD tied to venue / venue-night. (Note: a dashboard `promotions` feature exists but no backend module.) |
| `media` | **BUILD** | S3 upload via `common/storage`; venue photos immediate; user photos → curation queue state machine (§13.1). |
| `attribution` | **BUILD** | landing/acquisition event capture, structured params (`src`/`venue`/`pid`/`campaign`), **raw event store** kept (§11.3). |
| `analytics-proxy` | **BUILD** | server-side PostHog proxy, PII minimization, event taxonomy (§11.2). |
| `notifications` | **BUILD** | FCM; Thu 17:00 digest + 20:00 going reminder (BullMQ schedules); opt-in venue broadcast + rate limit (§12). |

### 1.6 Backend housekeeping

| Item | Verdict | Action |
|---|---|---|
| `Vyba-backend/templates/` (Handlebars email templates) | **DEFER** | Unused in v1; leave. |
| `common/database/migrations` (empty) | **BUILD** | Dev uses auto-sync; generate migrations before the cohort (prod). |
| `.env.example` | **MODIFY** | Add SMS, PostHog, WhatsApp, Zone4 polygon, S3 bucket groups. |
| Swagger `/api/docs` | **EXISTS** | Keep — it is the progressive API contract (§18.3). |

---

## 2. Vyba-mobile-app/

### 2.1 Core (`lib/core/`) — mostly keep

| Component | State | Verdict | Action |
|---|---|---|---|
| `theme/` (colors, spacing, radius, shadows, typography, gradients, effects, motion, haptics) | Vyba design tokens present | **EXISTS** | Keep. Design pass (§17) refines the 4 consumer surfaces, not the tokens. Verify brand palette matches CLAUDE.md (Electric Indigo, Abidjan Emerald, Golden Hour, Error). |
| `network/` (DioClient, Logging→Auth→Error interceptors, QueuedInterceptor 401 refresh) | Solid | **EXISTS** | Keep. Point `BASE_URL` at the real API; verify no token/PII logging (security.md). |
| `router/` (GoRouter, `StatefulShellRoute`, role redirect, analytics observer) | Client/Owner shells wired | **MODIFY** | Client shell tabs → Feed / Explore(map+list) / (drop Bookings) / Profile. Owner shell → the 4-action set (§10). Remove routes for deleted features. `_publicPaths` fine. |
| `error/` (`Either<Failure,T>`, exceptions, failures) | Clean-arch plumbing | **EXISTS** | Keep. |
| `usecase/`, `providers/`, `storage/`, `widgets/`, `database/` | Generic | **EXISTS** | Keep `database/` only for the last-feed/venue read cache. |
| `sync/` (offline-first queue, Drift) | Full sync engine | **DELETE** | Spec §8.2 cuts the sync engine. Remove `core/sync/` + the Drift write-queue. Keep a plain read cache only. |
| `enums/user_role.dart` | `client` / `venueOwner` | **EXISTS** | Matches spec intent. Align string values with backend (§1.3). |
| `services/` (analytics_service, crash reporter) | Interface present | **MODIFY** | Implement against PostHog (§11); wire the §11.2 events. |
| `.env` `USE_MOCK_AUTH` | present, must default false | **EXISTS** | Verify default `false` (security.md / CLAUDE.md). |

### 2.2 Features — verdict per folder

| Feature | State | Verdict | Action |
|---|---|---|---|
| `auth` | Pages for login/register/**otp**/forgot-password; `login_with_phone_usecase` + `verify_otp_usecase` **already exist**; also `login_usecase`, `register_usecase`, `social_login_buttons` | **MODIFY** | Keep phone + OTP path (good head start). **DELETE** `social_login_buttons.dart`, `forgot_password_*`, email `login_usecase`/`register_usecase`, `user_model` email fields. Wire to real `auth` API. |
| `splash`, `onboarding`, `role_selection` | Present | **EXISTS** | Keep. Onboarding copy → FR, add 18+ confirmation (§16). Role selection stays (client vs owner entry). |
| `home` (client_shell, owner_shell, profile, settings) | Shells present | **MODIFY** | Rework shell tabs (§2.1 router). Trim `settings_page` to essentials (notif prefs, "Un problème ?"→WhatsApp, legal links, delete account). |
| `venues` | Real + mock datasources, entity, detail/explore/menu pages, filter, list/detail notifiers | **MODIFY** | Keep as the discovery surface. **Remove** `venue_menu*` (menus out of scope), `₦` price label → FCFA, `openingHours` field, `hasVipPass`. `VenueType`: drop `rooftop`/`beachClub` (keep club/bar/lounge/maquis; `restaurant` unused). Add `VenueNight`-derived "live tonight" + going count to detail. Wire real API. `search_venues_usecase` → simple filter. |
| `feed` | **Mock-only**. Entity has only `PromoFeedItem` + `EventFeedItem` | **MODIFY** (large) | Rebuild entity as polymorphic `FeedItem` with all 7 types (§3.2). Real datasource. Server-driven ranking (client just renders). This is the core loop — gets the design pass. |
| `going` (new) | Does not exist — closest is `bookings` | **BUILD** | New feature: "J'y vais" action, aggregate count display, ~20:00 reminder opt-in, editable-until-midnight. Carve UI from `book_table` flow if useful, then delete bookings. |
| `bookings` | Mock-only; `book_table_page`, `booking_confirmation_page`, `my_bookings_page` | **DELETE** | Replaced by `going`. Salvage any reusable "party size" / confirmation UI into `going` first. |
| `favorites` | Mock-only; toggle + list | **MODIFY** → merge | Rename/refactor into **Follow venue** (§8.3). Keep toggle + list mechanics; wire to `follows` API. |
| `promotions` | Mock-only; `create_promotion_page` | **MODIFY** | Keep create page for the owner app (fast create, <10s). Wire to `promotions` API + `assisted=false` when owner-created. |
| `notifications` | Mock-only; list page + entity | **MODIFY** | Keep list UI; wire to FCM + real API; reflect the 2 recurring types + venue broadcasts (§12). |
| `owner_dashboard` | Mock-only; stats + activity entities | **MODIFY** | Reduce to the 4 actions (§10) + owner-home value stats ("84 vues · 31 J'y vais"). |
| `venue_management` | Mock-only; edit/my-venues pages | **DEFER** | §10: venue profile editing is team/dashboard-only during validation. Leave scaffolded, unrouted. |
| `owner_analytics` | Mock-only | **DEFER** | §8.2 cut from owner app. Leave scaffolded, unrouted. |
| `owner_bookings` | Mock-only | **DELETE** | No bookings in v1 at all. |
| `reviews` | Mock-only; write-review, review card | **DEFER** | §8.2 cut. Leave scaffolded, unrouted. Do not delete (keeps the pattern for post-gate). |
| `search` | Single page, no logic | **DELETE** | §8.2 → replaced by a filter on the venue list. |
| `notes` + `core/sync` | Full offline-sync demo feature (Drift DAO, tables, sync handler) | **DELETE** | Template demo. Out of scope; removing it is also the cleanest way to retire the sync engine. |

### 2.3 Mobile new work not covered by a folder

| Item | Verdict |
|---|---|
| `VenueNight`-aware venue detail (live status, tonight's headline, going count) | **BUILD** |
| PostHog event instrumentation across §11.2 events | **BUILD** |
| Deep-link / attribution capture on install + first open | **BUILD** |
| Last-feed + venue-list read cache (replacing sync engine) | **BUILD** (small) |
| FR-only localization pass; remove `app_en.arb` from build; add Abidjan register strings (§2) | **MODIFY** |
| Google Maps SDK + dark map style JSON | **BUILD** |
| "Un problème ?" → WhatsApp deep link | **BUILD** (small) |
| Package rename `flutter_templates` → real name | **DEFER** (cosmetic; not blocking) |

---

## 3. Vyba-dashboard-admin/

The CRUD-resource pattern (schema + mock + table + dialogs + context) is reusable
infrastructure. The *features* are mostly the wrong six and are wired to mock data.

### 3.1 Shell / infra — keep

| Component | Verdict | Action |
|---|---|---|
| Auth (`(auth)/sign-in`, `otp`, `forgot-password`, `sign-up`), Zustand `authStore` (cookie token), route guards | **MODIFY** | Keep `otp` route; switch admin auth to phone-OTP or keep email for internal team (decide — team-only tool, email may be acceptable). Remove `sign-up` (no self-serve admins). |
| Axios instance + interceptors + `endpoints.ts` + typed responses | **EXISTS** | Point at real API; add new endpoints. |
| shadcn/ui primitives, `data-table-*`, motion wrappers, `cn()`, `src/index.css` tokens | **EXISTS** | Keep. Consolidate the duplicated `data-table-*` into `components/ui/data-table/` as noted in dashboard.md. |
| TanStack Query / Router setup | **EXISTS** | Keep. |
| i18n `en.json` / `fr.json` | **MODIFY** | Team tool — English is acceptable here; low priority. Not user-facing. |

### 3.2 Features vs the six §13 cockpit surfaces

| §13 surface | Closest existing | Verdict | Action |
|---|---|---|---|
| 1. Venue + owner provisioning | `features/venues` (schema, table, dialogs — mock; `venues/applications` route) | **MODIFY** (large) | Repurpose `venues` into provisioning: create venue + geo + photos; **add** create/bind owner account flow; venue validation status. Drop "applications" (no self-serve claims). Wire real API. |
| 2. Editorial composer | — | **BUILD** | New lightweight feature: `FeedItem type=editorial`, area/venue assoc, publish/expire, draft state. Not the CRUD-table pattern — a compose form + list. |
| 3. Assist mode | `features/promotions` (mock) | **MODIFY** → extend | Create promo / venue_update / live_tonight **on behalf of a venue**; server stamps `assisted=true` + real creator. Reuse promo form. |
| 4. Photo curation queue | — | **BUILD** | New: queue of user `VenueNight` photos → promote / hide / delete. |
| 5. VenueNight monitor | `features/dashboard` (generic widgets) | **MODIFY** | Rebuild the dashboard home as "tonight's venues": live status, going count, recent activity, intervene list. |
| 6. Validation metrics | `features/analytics` (mock charts) | **MODIFY** (large) | Rebuild around §23 gates from first-party Postgres + PostHog links: Zone 4 WAU, week-4 retention, organic vs assisted posting, going/night, active venues. |

### 3.3 Features to DEFER / DELETE

| Feature / route | Verdict | Action |
|---|---|---|
| `features/bookings` + route + sidebar entry | **DEFER** | No bookings in v1. Unroute, remove from sidebar. Keep code. |
| `features/reviews` + route + sidebar entry | **DEFER** | Cut (§8.2). Unroute, remove from sidebar. |
| `features/tasks` + route | **DELETE** | Template demo, never Vyba. |
| `routes/_authenticated/apps/` | **DELETE** | Template demo. |
| `routes/_authenticated/audit-log/` | **DEFER** | Not in the six; nice-to-have later. Unroute. |
| `features/landing-page` + `_public/` | **DEFER** | Marketing site is separate concern; not validation. |
| `features/settings/*` (admins, appearance, notifications, platform, security, profile) | **MODIFY** | Trim to: team-member admin (add/remove provisioning accounts), appearance. Drop `platform`/`security`/`notifications` settings pages for now. |
| `features/users` | **MODIFY** | Keep minimal — view users, see acquisition source, basic support lookup. Not full CRUD. |
| `features/notifications` (route + sidebar) | **DEFER** | Broadcast tooling is post-gate; the 2 recurring notifs are backend-scheduled. Unroute. |
| Sidebar `sidebar-data.ts` | **MODIFY** | Rebuild nav around the 6 surfaces. (`teams` plan label "Abidjan Pulse", `admin@vyba.app` already Vyba-branded.) |

---

## 4. Cross-cutting BUILD (no home in any current project)

| Item | Verdict | Notes |
|---|---|---|
| **QR / mobile-web surface** (React/Next, lightweight, same API) | **BUILD** | New project/package. Venue page + read-only Zone 4 feed + phone-OTP "J'y vais". <1s target, 2.5s ceiling (§6.2, §20.3). |
| PostHog project + EU hosting + event schema | **BUILD** | §11. |
| SMS provider account + "Vyba" sender ID registration | **BUILD** | Long lead time — start now (§14.1). |
| WhatsApp Business number + support log template | **BUILD** | §22.4. |
| Hosting (eu-west-3 / Scaleway): managed Postgres, Redis, object storage | **BUILD** | §14.2. |
| Zone 4 / Marcory boundary polygon (shared config) | **BUILD** | §23.2 — one canonical definition consumed by backend + metrics. |
| FR Privacy Policy + ToS + ARTCI filing (local counsel) | **BUILD** | §16 — pre-launch blocker. |
| Venue onboarding kit (QR print template, owner 1-pager, starter-content checklist) | **BUILD** | §22.1 — design-system'd. |
| Editorial calendar + 4 format templates | **BUILD** | §22.2. |
| Pre-cohort QA checklist + dogfood exit checklist (§20, §21) | **BUILD** | Written go/no-go. |
| 3 low-end Android test devices (Tecno / Infinix / itel) | **BUILD** (procure) | §20.1. |

---

## 5. Suggested first moves (weeks 1–2)

1. **Backend reset:** fix `roles.constant` domain; convert `auth` to phone-OTP + Redis code
   store; convert `user.entity` to phone-first. Stand up `venues` + `venue-nights` +
   `feed` + `going` entities with migrations.
2. **Kill dead weight now** (small, unblocks clarity): delete mobile `notes/` + `core/sync/`,
   `search/`, `owner_bookings/`; delete dashboard `tasks/` + `apps/`.
3. **Start the long-lead items:** SMS provider + sender ID, hosting accounts, PostHog
   project, local legal counsel for ARTCI.
4. **Freeze the Zone 4 polygon** and the §11.2 event names — both are referenced everywhere
   downstream.
5. Stand up the **QR/web** project skeleton so its API needs shape the backend contract early.

---

*Open question flagged during audit:* admin dashboard auth — keep email+password for the
internal team, or move it to phone-OTP too? Spec §7 is about end users; the team tool can
reasonably stay email. Recommend: **keep email+password for dashboard**, remove self-serve
`sign-up`.
