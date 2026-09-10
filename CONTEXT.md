# Vyba — Product & Domain Context

Stable product and domain knowledge for the whole project. Read this before working
in any sub-project. It defines *what the words mean*; it is not a spec and not an
implementation guide.

- Navigation and non-negotiable rules: `CLAUDE.md`
- Sub-project domain boundaries: `Vyba-backend/CONTEXT.md`, `Vyba-mobile-app/CONTEXT.md`,
  `Vyba-dashboard-admin/CONTEXT.md`
- Decisions and their rationale: `docs/adr/`
- The current build target: `docs/validation-mvp/VYBA_VALIDATION_MVP_SPEC.md`

---

## What Vyba is

A nightlife discovery and coordination platform for Abidjan, Côte d'Ivoire. It
connects people going out with nearby venues (bars, lounges, nightclubs, and
*maquis*), and gives venue owners tools to broadcast what is happening and attract
customers in real time.

The product centralises three things that are otherwise scattered: **discovery**
(what's happening tonight near me), **promotion** (venues announcing events, DJs,
offers), and **coordination** (signalling intent to go out).

## Phase: validation

The project is in a **validation phase**, not a general build-out. The goal is to
prove one core loop works, with real venues and real users, in one dense area
before expanding.

- **Launch area:** Zone 4 / Marcory (one commune), not all of Abidjan.
- **Core loop:** *Découvre → Vois ce qui se passe → Décide → J'y vais → Vis la
  soirée → Reviens la semaine suivante.*
- **Scope rule:** anything that does not strengthen that loop is out of the
  validation build. Many capabilities named below (real booking, reviews, boosts,
  SaaS billing) are **deferred to post-validation** — see the spec for the exact
  in/out list.

## Actors

| Actor | Who | In the product |
|---|---|---|
| **Client** | Someone going out in Zone 4 | Browses the feed, follows venues, marks "J'y vais", discovers venues on the map |
| **Venue owner** | A bar / lounge / nightclub / maquis manager | Posts venue updates and promotions, marks the venue live, sees attendance intent. Accounts are provisioned by the Vyba team, not self-serve. |
| **Vyba team** | Founding / operations team | Onboards venues, creates editorial content, curates photos, monitors activity, runs the validation experiment. Works through the admin dashboard. |

The client-side notion of role is a UX hint only. The **backend is the source of
truth** for identity and permissions.

## Core domain concepts (glossary)

- **Venue** — a physical nightlife establishment in the launch area. Team-managed
  during validation (no self-serve claiming).
- **VenueNight** — *one venue + one calendar night.* The temporal spine of the
  product: all night-scoped state (live status, attendance intent, tonight's
  headline/DJ, night-specific promos and photos) belongs to a VenueNight, never to
  mutable fields on Venue. See ADR-0001.
- **Feed** — the primary surface. A venue-broadcast stream (with a thin social
  layer) answering "qu'est-ce qui se passe ce soir ?". Ranked by time-relevance
  (tonight > weekend > upcoming > recent > evergreen) plus an activity boost.
- **FeedItem** — a single feed entry. One polymorphic type with a `type`
  discriminator: `venue_update`, `live_tonight`, `promo`, `event`, `editorial`,
  `going_milestone`, `photo`. Every item records who created it and whether the
  Vyba team assisted (`assisted`) — this distinction is load-bearing for the
  validation metrics and is enforced server-side. See ADR-0005-adjacent notes in
  the spec.
- **"J'y vais" (going / intent signal)** — a low-friction "I'm coming tonight
  (with N people)" signal. It is **not** a guaranteed reservation. Shown publicly
  as an aggregate count ("23 personnes y vont ce soir"); identity is private by
  default. One per user / venue / night, resets daily. See ADR-0002.
- **Follow** — a client subscribing to a venue's updates. (Absorbs the older
  "favourites" idea.)
- **Promotion** — a venue offer or event announcement, shown in the feed, usually
  tied to a VenueNight.
- **Live status** — a one-tap "on est live ce soir" flag on a VenueNight; the
  lightweight alternative to maintaining structured opening hours.
- **Editorial** — feed content authored by the Vyba team (e.g. "Ce soir à Zone 4",
  "5 spots chauds ce soir") to keep the feed useful on quiet nights. A bootstrap
  mechanism, not a permanent content engine.
- **Boost** *(post-validation)* — a paid placement increasing a venue's visibility
  in feed/discovery. The intended primary revenue line; not built during
  validation.
- **Acquisition attribution** — every entry point (venue QR code, promoter link,
  social campaign) carries structured params so retention can be analysed by
  source. `acquisition_zone` (where a user came from) and `active_zone` (whether
  they engage with Zone 4) are tracked separately and never conflated.

## Surfaces

- **Native app (Flutter)** — the power surface: personalised feed, following,
  notifications, map, persistent identity. Two role shells (client / owner).
- **QR / mobile-web** — a separate lightweight web surface (not the Flutter web
  build) reached by scanning a venue's QR code. Read-mostly: venue page + "J'y
  vais" + a link into Zone 4 discovery. Optimised for a first-time visitor on a
  poor connection. See ADR-0004.
- **Admin dashboard (React)** — the Vyba team's internal operational cockpit.

## Identity

Phone number + OTP is the **sole** identity primitive. No email/password, no social
login. The phone number is the canonical user identity across app and web. See
ADR-0003.

## Key invariants

1. The backend re-validates identity and permissions on every request; clients are
   never trusted.
2. Night-scoped state lives on a **VenueNight**, never as resettable fields on
   Venue.
3. Whether the Vyba team assisted a piece of content (`assisted`) is recorded and
   enforced at the domain level, not left to UI discipline.
4. The "J'y vais" count reflects genuine intent — owners cannot inflate their own
   count; abuse is guarded server-side.
5. Dark-first UI, no-line rule, project tokens only. Nightlife is a visual
   category; the consumer surfaces get real design investment.

## Language

French only for the validation build. Standard French for structural UI; a
deliberate Abidjan nightlife register for social moments ("On bouge où ce soir ?",
"C'est live ce soir"). Native to Abidjan, not translated into it.
