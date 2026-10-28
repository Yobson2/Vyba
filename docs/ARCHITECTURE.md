# Architecture

How Vyba's five applications fit together, and the domain model that runs
through them. This document is a map. Each app's internals live in its own guide
([backend](backend.md) · [mobile](mobile.md) · [dashboard](dashboard.md)), the
vocabulary lives in [`CONTEXT.md`](../CONTEXT.md), and the *why* behind each
decision lives in the [ADRs](adr/README.md).

## System overview

```mermaid
flowchart TB
  subgraph Public["Public surfaces"]
    LP["vyba-landing-page<br/>Next.js 16 · static marketing site"]
    QR["Vyba-web<br/>Next.js 15 · QR-scan venue page"]
  end
  subgraph Apps["Authenticated clients"]
    MA["Vyba-mobile-app<br/>Flutter · client + owner shells"]
    AD["Vyba-dashboard-admin<br/>React · Vyba team cockpit"]
  end
  subgraph Backend["Vyba-backend (NestJS 11)"]
    API["REST /api/*<br/>+ Swagger /api/docs"]
    WS["Socket.IO gateway<br/>(not used by clients yet)"]
    Q["BullMQ workers<br/>(notifications)"]
  end
  PG[("PostgreSQL 16")]
  RD[("Redis<br/>cache · OTP store · queues")]
  S3[("S3-compatible storage<br/>MinIO in dev")]
  FCM["Firebase Cloud Messaging"]

  QR -- "public endpoints · phone OTP for J'y vais" --> API
  MA -- "JWT access + refresh" --> API
  AD -- "admin JWT" --> API
  API --> PG
  API --> RD
  Q --> RD
  API --> S3
  Q --> FCM
```

| App | Talks to | Notes |
|---|---|---|
| Mobile app | API (JWT) | The "power surface": personalised feed, follows, notifications, owner tools |
| QR web surface | API public endpoints | Read-mostly. Must show meaningful content in under 1 s, with a 2.5 s ceiling ([ADR-0004](adr/0004-separate-lightweight-web-surface.md)) |
| Admin dashboard | API (admin JWT) | Venue onboarding, editorial, curation, metrics |
| Landing page | Nothing | Static HTML. CTAs link to Google Play and WhatsApp |

## Domain model

All night-scoped state hangs off a **VenueNight**, meaning one venue on one
calendar night, never off mutable fields on `Venue`
([ADR-0001](adr/0001-venuenight-as-temporal-spine.md)).

```mermaid
erDiagram
  USER ||--o{ GOING : "says J'y vais"
  USER ||--o{ FOLLOW : follows
  USER ||--o{ RESERVATION : requests
  USER ||--o{ DEVICE_TOKEN : registers
  USER ||--o{ NOTIFICATION_PREFERENCE : sets
  VENUE ||--o{ VENUE_NIGHT : "has one per night"
  VENUE ||--o{ FOLLOW : "is followed"
  VENUE ||--o{ VENUE_BROADCAST_OPT_IN : "opt-ins"
  VENUE_NIGHT ||--o{ GOING : "collects intent"
  VENUE_NIGHT ||--o{ RESERVATION : "same-night requests"
  VENUE_NIGHT ||--o{ FEED_ITEM : "night-scoped posts"
  VENUE ||--o{ FEED_ITEM : posts
  VENUE ||--o{ MEDIA_ASSET : photos
  USER ||--o{ ACQUISITION_EVENT : "attribution"
```

Entities live in `Vyba-backend/src/modules/*/entities/`. Schema changes ship as
TypeORM migrations in `Vyba-backend/src/common/database/migrations/`.

| Concept | Rule worth knowing |
|---|---|
| **Going ("J'y vais")** | One per user, venue and night; editable until midnight. Public output is an aggregate count. Owners can't inflate their own count ([ADR-0002](adr/0002-soft-jy-vais-intent-instead-of-reservations.md)) |
| **FeedItem** | One polymorphic type: `venue_update`, `live_tonight`, `promo`, `event`, `editorial`, `going_milestone`, `photo`. Records `created_by` and whether the team **assisted**, which the validation metrics depend on and the server enforces |
| **Reservation** | Opt-in per venue (`reservationsEnabled`), same-night only, capacity-gated, confirmed by the owner ([ADR-0006](adr/0006-optional-per-venue-reservations.md)) |
| **Venue discovery** | Not geofenced: any active venue is discoverable by text or proximity ([ADR-0005](adr/0005-venue-discovery-not-geofenced.md)) |

## Key flows

### Feed ranking
Computed **server-side at request time**, with no per-user precomputed feeds
(`src/modules/feed/feed-ranking.util.ts`). Items are bucketed into tiers
`TONIGHT → THIS_WEEKEND (Thu–Sun) → UPCOMING → RECENT (48 h) → EVERGREEN`, then
ordered within each tier by recency. A followed venue's items get a bounded
3-hour lift, which never crosses a tier boundary. The spec's going-count
boost is not implemented yet; the code leaves it for a future ticket.

### Phone + OTP sign-in
```mermaid
sequenceDiagram
  participant C as Mobile app / QR web
  participant A as API (auth module)
  participant R as Redis (OTP store)
  participant S as SMS provider
  C->>A: POST /api/auth/request-code {phone}
  A->>R: store code (TTL) + rate-limit counters
  A->>S: send code
  C->>A: POST /api/auth/verify-code {phone, code}
  A->>R: verify, count attempts
  A-->>C: access + refresh JWT (same account across app and web)
```
Phone number is the only identity primitive ([ADR-0003](adr/0003-phone-otp-as-sole-identity.md)).
The admin dashboard uses a separate email + password login
(`/api/auth/admin/login`). The first admin can be bootstrapped with
`SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD`.

> **Current state:** only a `FakeSmsProvider` exists (`src/common/sms/`), so no
> code is actually sent. See [Known limitations](../README.md#known-limitations).

### QR acquisition
`venue table QR → Vyba-web /[venueId]?src=qr… → venue night + going count →
phone OTP → "J'y vais" → Zone 4 feed → app install prompt (only after value)`.
Attribution parameters are captured at landing (`/api/attribution/landing`) and
kept separate from the user's active zone, so retention can be analysed by source.

### Scheduled notifications
BullMQ repeatable jobs on the notifications queue (Africa/Abidjan is UTC+0):

| Job | Schedule |
|---|---|
| Weekend digest | Thursday 17:00 (`0 17 * * 4`) |
| "J'y vais" reminder | Daily 20:00 (`0 20 * * *`) |

## Cross-cutting rules

- **The backend is the source of truth.** Every request is re-validated, and
  client-side roles are UX hints only.
- **Security:** HTTPS only, never log tokens, OTPs or PII, and check JWT `exp`
  client-side before use. Full framework: [`security.md`](security.md).
- **Design:** dark-first, no pure black, no 1px borders, radius ≥ 8px, and
  semantic brand colours. See [`design-system.md`](design-system.md).
- **Language:** French only for the validation build.

## Per-app architecture

| App | Pattern | Guide |
|---|---|---|
| Backend | Modular NestJS: `src/modules/<feature>` on shared `src/common/` (config, database, guards, redis, queues, storage, sms, firebase, websockets…) | [`backend.md`](backend.md) |
| Mobile | Clean Architecture per feature (`domain` / `data` / `presentation`), Riverpod DI, GoRouter role shells | [`mobile.md`](mobile.md) |
| Dashboard | Feature folders; CRUD resources as TanStack Tables with dialog-driven create/edit | [`dashboard.md`](dashboard.md) |
| QR web | Next.js App Router with React Server Components; MSW-mocked API as the test seam | [`../Vyba-web/README.md`](../Vyba-web/README.md) |
| Landing | Next.js SSG, feature sections, code-rendered device previews | [`../vyba-landing-page/README.md`](../vyba-landing-page/README.md) |
