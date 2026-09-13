# Vyba — Validation MVP Specification

**Status:** Approved for build · **Owner:** Yoboué (technical lead) · **Date:** 2026-09-10

This document is the single source of truth for the Vyba validation phase. It is the
output of a full design interrogation and every item here is a committed decision, not
a suggestion. Changes require an explicit revision with rationale.

Scope discipline: **anything that does not strengthen the core loop is out of the
validation build.** The core loop is:

> **Découvre → Vois ce qui se passe → Décide → J'y vais → Vis la soirée → Reviens la semaine suivante**

---

## 1. Venture context

- Real early-stage startup. Self-funded / pre-seed. Intent to raise later.
- Not a portfolio project, not a capstone. Optimize for a **validated wedge**, not feature count.
- Yoboué is the phase "done" decision-maker.
- The validation phase exists to answer five questions:
  1. Do people discover nightlife through Vyba?
  2. Do they find something relevant enough to act on?
  3. Do they use **J'y vais**?
  4. Do venues independently contribute content?
  5. Do users return the following week?

Everything else is secondary until those are answered.

---

## 2. Market & launch scope

> **Superseded on discovery visibility by [ADR-0005](../adr/0005-venue-discovery-not-geofenced.md):**
> venue discovery is no longer geofenced to Zone 4 — this section is kept as
> the historical record of the original validation-phase launch scope.

- **City:** Abidjan, Côte d'Ivoire.
- **Launch area:** one high-density nightlife zone — **Zone 4 / Marcory**. Not all of
  Abidjan. Not Côte d'Ivoire.
- **Strategy:** go deep, not broad. ~20–40 hand-onboarded venues forming a coherent
  local nightlife network, not a directory.
- **Success = density + engagement inside the launch area**, not total venue coverage.
- **Language: French only** for v1. English is removed from the build.
  - Standard French for structural/product UI.
  - Deliberate Abidjan nightlife register for social moments: *"On bouge où ce soir ?"*,
    *"Qui est chaud ce soir ?"*, *"Ça se passe où ?"*, *"C'est live ce soir"*, *"Qui y va ?"*.
  - Native to Abidjan, not mechanically translated into French. Used deliberately, not forced onto every screen.
- **Currency / symbols:** no Naira (`₦`). Use FCFA / XOF where a price indication is shown.

---

## 3. Product model

### 3.1 The feed is the core loop

- **Venue-broadcast first**, with a thin social layer.
- Users follow venues; the default experience is a **Zone 4 "Ce soir"** feed for users
  deciding what is happening around them.
- **No friend graph, no messaging, no full social network** in the validation wedge.
- User-generated activity exists but stays lightweight: "going" counts and curated user
  photos can appear in the feed as social proof.

**Feed principle:** Vyba answers *"Qu'est-ce qui se passe ce soir ?"* better than a generic
social network — it does not try to become one.

### 3.2 Feed content types

Single polymorphic `FeedItem`. Initial types:

| Type | Source |
|---|---|
| `venue_update` | venue / team |
| `live_tonight` | venue (one-tap) / team |
| `promo` | venue / team |
| `event` | venue / team |
| `editorial` | founding team |
| `going_milestone` | system (generated from going activity) |
| `photo` | venue (immediate) / user (curated) |

A `FeedItem` optionally references: `venue_id`, `venue_night_id`, `created_by`,
`starts_at`, `expires_at`. It records origin: **venue-created / founder-created /
founder-assisted / user-generated**.

### 3.3 Feed ranking

Computed **server-side at request time** (the feed is small — no per-user precomputed feeds).

Priority tiers:

1. Ce soir (tonight)
2. Ce week-end (this weekend)
3. À venir (upcoming)
4. Récent
5. Evergreen venue content

Then apply: going/activity boost · recency decay · relevance · content freshness.

Keep this deliberately simple until real usage data justifies more.

- Event-specific posts **auto-expire after the event date** (the following morning).
- Feed acknowledges nightlife is concentrated **Thursday–Sunday**; still useful Mon–Wed via
  upcoming events, promotions and weekly-planning content.

### 3.4 Feed density

- Target ≈ **15–20 meaningful feed items per day** during validation.
- This is not 15–20 traditional venue posts — it includes venue updates, promos, events,
  going activity, photos, and editorial.
- Every item must help answer *"Qu'est-ce qui se passe à Zone 4 ?"* — no artificial volume.

Gap-fillers for slow days:

1. **Low-friction venue content** — one-tap actions ("On est live", "DJ ce soir",
   "Happy hour", "Musique live", photo). A one-tap "On est live ce soir" counts as
   meaningful feed content.
2. **Going activity + curated user photos** as first-class feed items.
3. **Light editorial** — ~1 useful item per weekday from the founding team. Bootstrap
   only; the team is not the permanent content engine.

---

## 4. "J'y vais" — the intent signal (the wedge)

- **Soft intent, not a guaranteed reservation.** *"Je viens ce soir avec 4."*
- Objective: reduce friction and avoid forcing maquis / neighbourhood bars to adopt
  reservation workflows.
- **Aggregate social proof by default:** *"23 personnes y vont ce soir"*.
  User identity is **not public by default**; opt-in to show identity.
- **One "going" per user / venue / night.** Editable/cancellable by the user until midnight.
- The public aggregate represents **tonight only** and resets/decays the following day.
- **Venue owners cannot manipulate their own going count.**
- **No geofencing enforcement** at launch. Where technically appropriate and consented,
  log proximity anonymously for later signal-quality analysis.
- Backend must protect against obvious abuse (repeat submissions from the same
  account/session).

**On the venue side, the owner sees:**
- Current number of people going
- Approximate party sizes
- Activity by night
- **No approval or response required.**
- Optional: a one-tap broadcast to people who marked "going" (not part of the core workflow).

**On the user side, "J'y vais" provides:**
- Confirmation
- Current aggregate attendance count
- Optional reminder around ~20:00

The going count is also a **feed-ranking signal** — genuine user intent ranks stronger
than a plain promotional post. The signal must represent genuine intent, never a vanity metric.

**Real VIP / table booking** is a **post-validation** layer, introduced progressively for
higher-end lounges where that behaviour already exists.

---

## 5. Monetization (deferred — follows evidence)

- **Primary:** paid discovery/feed **boosts**. Venues pay to increase visibility of
  promotions / events / venue content. Activated **only after** sufficient audience + engagement.
- **Secondary:** low-cost **monthly SaaS subscription** for venue owners (extra
  management + promotional capabilities).
- **Not** commission-per-booking — the booking mechanism is intentionally lightweight and
  transaction commissions would add friction.
- **Nothing is billed during validation.** Boosts and SaaS billing are **not built** until
  after the validation gate is passed.
- Sequence: **validate engagement → validate organic supply → validate monetization → expand.**

---

## 6. Surfaces

### 6.1 Native app (Flutter) — power surface

Personalized feed, following venues, notifications, richer discovery, map, persistent
user experience.

### 6.2 QR / mobile-web surface — acquisition hook

- **Purpose-built lightweight web app (React / Next or equivalent).** **Never the Flutter
  web build.**
- Backed by the same Vyba API and the same user identity.
- **Read-mostly.** Flow: **QR → venue page → "J'y vais" → "Voir ce qui se passe à Zone 4"**.
- Venue page contains: venue identity · tonight's status/activity · current going count ·
  tonight's promo/event · minimal venue info · "J'y vais" · link to Zone 4 discovery.
- **Performance:** meaningful venue content visible in **< 1 second where realistically
  achievable**, **2.5 seconds hard ceiling** on the critical path.
- Native app install is promoted **only after** the user has experienced value
  (notifications, following, personalized discovery, recurring use) — **never before**.
- No interactive map on web: static map representation + venue location + "Ouvrir dans
  Google Maps".

**Principle:** never ask the user to install before showing them why Vyba is useful.

---

## 7. Identity & accounts

- **Phone number + OTP is the only identity primitive for v1.** No Google / Apple /
  Facebook / social auth.
- The phone number is the **canonical user identity**.
- Web "J'y vais" **requires phone + OTP** verification. **Anonymous going is excluded** —
  it would make the core validation metric too easy to manipulate. After verification the
  web session persists (no repeated OTP within a session).
- If a user later installs the native app and authenticates with the **same phone number**,
  it is the same account and existing "going" history / activity remains associated.
- **One app, role-gated** (client shell / owner shell).

### Venue owner accounts

- **Provisioned by the founding team** during physical onboarding:
  **Founder visits venue → verifies owner/manager → creates account → binds account to
  venue → grants owner access.**
- **No self-service venue claiming or owner registration in v1.** Venue ownership is part
  of the trust model during marketplace seeding.

---

## 8. v1 scope

### 8.1 IN

| Capability | Notes |
|---|---|
| Phone OTP authentication | Phone + OTP only. No email/password, no social. |
| Feed | Core product. Polymorphic `FeedItem`, server-side ranking. |
| Venue profiles | Minimal. |
| Promotions | Fast create / view. |
| **"J'y vais"** | Core wedge. Own feature / cleanly separated from any "booking" concept. |
| Follow venue | Absorbs the old "favorites" concept. |
| Notifications | Tightly controlled — see §12. |
| Last-feed / venue-list read cache | Read-only offline display. No sync engine. |
| Map | Google Maps SDK. Conversion surface only. |
| VenueNight (domain) | Temporal spine — see §9. |
| Owner minimal app | 4 actions — see §10. |
| Admin dashboard (6 surfaces) | See §13. |

### 8.2 CUT / DEFERRED to post-validation

| Item | Decision |
|---|---|
| Real table / VIP booking | CUT — replaced by "J'y vais". Post-gate layer for lounges. |
| Reviews (ratings, review UI, review feed, moderation, workflows) | CUT. Data model must not make future reviews impossible, but nothing is built now. |
| Notes | CUT. |
| Search | CUT — replace with a minimal filterable venue list (~30 venues in one commune). |
| Structured opening hours / "open now" | CUT — replaced by the "On est live ce soir" venue signal + going count. No 7-day schedules maintained for 30 maquis. |
| Offline sync engine + conflict resolution (`core/sync`, `notes` sync, Drift queue) | CUT the engine. Keep only a last-feed / venue-list read cache. |
| Owner analytics (in owner app) | CUT from owner app — founding-team/dashboard only. |
| Owner booking management (in owner app) | CUT from owner app. |
| Boosts | POST-VALIDATION. |
| SaaS billing | POST-VALIDATION. |
| Social login buttons | CUT. |
| Dashboard: booking mgmt, reviews mgmt, landing-page mgmt, generic task mgmt, deep settings, complex admin analytics | CUT for validation — may remain scaffolded/ignored. |

### 8.3 MERGED / REDUCED

| Item | Decision |
|---|---|
| Favorites | MERGED INTO "Follow venue" — one concept. |
| Owner dashboard | REDUCED to 4 actions (§10). |

---

## 9. Core data model

### 9.1 `VenueNight` — the temporal spine

`VenueNight` = **one venue + one calendar night**. Everything night-specific hangs off it:

- Live status + live-status timestamp
- Going activity + going count
- Night headline / DJ information
- Night-specific promotions
- Night-specific photos
- Night-level engagement metrics

Conceptual shape: `Venue → VenueNight → NightActivity`.

Natural queries: *"Qu'est-ce qui se passe dans ce lieu ce soir ?"* and *"Combien de
personnes y vont ce soir ?"*.

**The system must not rely on resetting fields like `going_count`, `live_since`, or
`is_live` directly on `Venue`.** The night is represented explicitly.

### 9.2 `FeedItem` — polymorphic

Single entity. Types per §3.2. Optional refs: `venue_id`, `venue_night_id`, `created_by`,
`starts_at`, `expires_at`.

**Every post records at minimum:**
- `created_by`
- `created_at`
- `updated_at`
- `assisted` (boolean — was it founder/team-assisted)
- `venue`
- post type

This must distinguish **founder-assisted content vs genuinely organic venue content**.

**`assisted` is enforced at the backend/domain level, not the admin UI.** It must be
difficult or impossible for admin workflows to create venue content without recording who
created it and whether it was assisted. Owner-created content ⇒ `assisted = false` unless a
team member explicitly participated.

### 9.3 Going count delivery

**Poll-on-view**, not Socket.IO, during validation. The client retrieves the current count
when opening / refocusing the relevant venue/night experience. Slight staleness is
acceptable. Real-time infrastructure is a post-gate decision if behaviour justifies it.

### 9.4 Attribution data (raw, not collapsed)

Keep raw acquisition/landing events available — **do not rely solely on a single
`acquisition_source` field on `User`**. See §11.

---

## 10. Owner-facing product

The owner app contains **only** the actions required to validate organic venue participation:

1. See tonight's "going" count
2. **"On est live ce soir"** (one tap)
3. Create a promotion (fast)
4. See basic activity

Target: an owner can publish a useful update in **under 10 seconds**.

**Owner home also surfaces concrete value** (to sustain posting before monetization exists):
- Page views, e.g. *"84 vues cette semaine · 31 J'y vais"*
- Simple weekly comparison where meaningful

Founder/admin-controlled during validation (NOT in the owner app): detailed analytics,
booking management, venue profile editing, advanced configuration, complex management workflows.

### 10.1 The organic-posting hypothesis (must be stated in-product docs)

> Venues will continue posting organically if Vyba makes the value generated by their
> activity visible, keeps posting friction below ~10 seconds, and provides lightweight
> human follow-up during the validation phase.

This is a **hypothesis under test**, not an assumption.

- **If** visible attention-proof + <10s friction + weekly human follow-up are **insufficient**
  to sustain organic posting → **this is a genuine finding about the Vyba model**, not
  something to be masked by increasing founder effort indefinitely.
- The experiment measures the transition: **founder-assisted → lightly assisted → organic**.
- If organic posting disappears as soon as founder assistance decreases → **validation
  failure for the current venue value proposition**.

### 10.2 Non-monetary incentive layer (build / commit)

- **Owner-home stats** (above) — build into the owner experience.
- **Weekly WhatsApp recap** from community-ops: views, J'y vais, activity generated,
  weekend performance, contextual recognition (*"Tu étais parmi les spots les plus
  consultés de Zone 4 ce week-end"*). Informative, **not a public competitive ranking**.
- **Discretionary "À la une ce soir"** free feed placement for venues that actively post.
  An activation mechanism, not a guaranteed reward and not a permanent business-model feature.
- **No public venue leaderboard** — it creates negative signalling for lower-performing venues.

---

## 11. Analytics, instrumentation & attribution

**Non-negotiable: analytics must exist before the validation cohort starts.**

### 11.1 Stack

- **PostHog** — behavioural analytics, funnels, retention cohorts, product usage.
  Configured with an **EU-hosted / data-residency-appropriate** setup consistent with the
  legal assessment.
- **PostgreSQL** — source of truth for business-critical data.
- **Server-side PostHog proxy** — minimize personal data sent to analytics. Use internal
  identifiers, **never** send phone numbers or direct identifiers unnecessarily.

### 11.2 Core events (taxonomy refinable during implementation)

`feed_opened` · `feed_item_viewed` · `venue_viewed` · `venue_followed` · `going_marked` ·
`going_cancelled` · `promo_viewed` · `promo_created` · `event_viewed` · `post_created` ·
`post_created_organically` · `post_created_founder_assisted` · `qr_landing_opened` ·
`app_install_started`

### 11.3 Acquisition attribution (build from day one)

Every acquisition link carries structured attribution parameters:

- **Venue QR:** `?src=qr&venue=<venue_id>` — every venue's QR code is unique.
- **Promoter:** `?src=promoter&pid=<promoter_id>` — each seeded promoter/DJ gets unique links.
- **Social campaign:** a unique campaign / deep-link identifier.

Signup / acquisition event records: `source` · `campaign` · `venue_id` (where applicable) ·
`promoter_id` (where applicable) · landing timestamp · signup timestamp.

The user's initial acquisition source may be associated with the user at account creation,
**but raw acquisition/landing events must remain queryable** so multi-touch history is not lost.

Dimensions kept distinct — never conflated:

- `acquisition_source`, `acquisition_venue_id`, `acquisition_zone` — *where did this user come from?*
- `active_zone` — *did this user actually engage with Zone 4?* (see §22.2)

PostHog must be able to answer: QR/promoter/social → signup conversion · activation rate by
source · week-4 retention by source · going rate by source · QR vs social conversion.

### 11.4 Promoters

- **Not a separate account type in v1.** A normal user account + attribution metadata (tag).
- No promoter dashboard / marketplace / commission system / promoter workflow.
- Limited event-posting capability *may* come later — not part of the wedge.

---

## 12. Notifications

Intentionally limited. **Two** default recurring notifications:

1. **Thursday ~17:00** — Zone 4 weekend digest.
2. **~20:00** — reminder for venues the user marked "going" that night.

Venue-triggered broadcasts: **opt-in per venue**, rate-limited to **~1 broadcast per venue
per night**.

**Principle:** notifications help someone decide where to go — they do not constantly interrupt.

Infra: FCM (Android).

---

## 13. Admin dashboard — the founding team's operational cockpit

Build **only** these six surfaces for validation. Reshape existing scaffold rather than
building parallel systems.

1. **Venue + owner provisioning** — create venue; provision owner account; bind owner↔venue;
   set venue coordinates; upload initial profile + photos; manage venue validation status.
2. **Editorial composer** — `FeedItem.type = editorial`; content; area/venue association;
   publish time; expiration; draft/published state. Not a full CMS.
3. **Assist mode** — create content on behalf of a venue (promo / venue update / live tonight).
   **Every assisted action auto-stamped `assisted = true` with the real creator identity,
   enforced server-side.**
4. **Photo curation queue** — review / promote-to-feed / hide / delete user-submitted
   VenueNight photos.
5. **VenueNight monitor** — tonight's venues: live status, going count, recent activity,
   recent posts. Operational view — *which venues are active tonight, which are quiet, where
   to intervene.*
6. **Validation metrics** — core validation metrics from first-party PostgreSQL + link to
   PostHog. Answers: WAU in launch area · week-4 retention · organic vs assisted posting ·
   going activity per night · active venues · content activity.

**Cut for validation:** booking management · reviews management · landing-page management ·
generic task management · deep settings · complex admin analytics.

### 13.1 Content trust model

- **Venue content** = trusted operational content → publishes immediately (provisioned accounts).
- **User content** = community content → curated before amplification. User photos attach to
  a `VenueNight`, are visible on the venue/night page immediately, and **only reach the main
  feed when a team member promotes them** during the daily editorial pass.
- v1 safety net: report · hide · hard-delete from admin · basic upload audit info. **No
  automated moderation platform** unless volume/risk justifies it.

---

## 14. Infrastructure & external dependencies

### 14.1 SMS / OTP — treated as a launch-risk item

- **Primary provider:** an **Africa-focused SMS provider with proven Côte d'Ivoire
  delivery** — not a global provider chosen for developer convenience.
- **Register the "Vyba" sender ID as early as possible** (operator approval has lead time).
- **WhatsApp OTP** may be a fallback — committed **only after** verifying provider, delivery
  path, cost and operational constraints.
- **Pre-launch structured delivery test** on **Orange CI · MTN CI · Moov Africa CI**,
  measuring: delivery success rate · latency · expiration behaviour · retry behaviour ·
  duplicate-code behaviour · cost per successful verification · failure reasons.
- **A sustained delivery rate below ~90% on a materially important network is a launch
  blocker / investigation trigger** — not to be dismissed as a product problem.

### 14.2 Hosting

- Backend + managed PostgreSQL + managed Redis + object storage, all in a **low-latency
  European region — Paris / eu-west-3 or an equivalent** (e.g. Scaleway).
- Managed infrastructure where practical. Keep the initial architecture simple and
  operationally manageable.
- **Data-residency and regulatory implications for Côte d'Ivoire must be verified with
  qualified local counsel** — do not assume EU hosting automatically satisfies all
  requirements.

### 14.3 Notifications infra

FCM (Android).

### 14.4 Do not build for scale

No infrastructure built purely because it may become useful later. Optimize for:
**fast validation + trustworthy data + minimal operational complexity.**

---

## 15. Distribution

- **Android-first**, via **Google Play Store** — closed testing track for the founding
  cohort, then production once the critical funnel is stable.
- **No sideloaded APKs** as the primary validation mechanism.
- **iOS:** TestFlight for founders / key promoters only if necessary. A full iOS App Store
  launch is **not required** to validate the Zone 4 wedge.
- The QR mobile-web experience ensures non-installing users still enter the core acquisition funnel.

---

## 16. Privacy, legal & launch readiness

**Pre-launch requirements, not post-validation work.** Before opening the cohort, Vyba must have:

- French-language **Privacy Policy**
- French-language **Terms of Service**
- Clear consent/notice around personal-data processing
- Clear explanation of analytics usage
- Defined data-retention periods
- Appropriate treatment of phone numbers
- Appropriate handling of location / proximity information
- Photo / content deletion mechanism
- **18+ confirmation** at signup (nightlife / alcohol context)
- Appropriate data-processing documentation and any **regulatory filings/notifications
  required in Côte d'Ivoire**

**ARTCI:** the exact obligations and filing procedure must be **verified with qualified
local legal/privacy counsel before launch** — do not assume a specific filing mechanism.

### 16.1 Initial retention policy (document + implement consistently)

- Active account information: retained while the account exists, subject to obligations.
- Detailed "going" history: ~12 months.
- Older "going" data: aggregate/anonymize where appropriate.
- User photos: retained until deleted by the user or removed under content policy.
- Analytics: retained only as long as necessary for product analysis and legal requirements.

These values are documented and implemented consistently — not arbitrary database decisions.

---

## 17. Design quality

The validation build receives a **real product-design pass** — not cosmetic work. If the
product looks unfinished or generic, weak retention may be misattributed to weak
product-market fit.

**Consumer surfaces receiving deliberate design treatment:**

1. Feed
2. Venue page
3. "J'y vais" flow
4. QR mobile-web experience

Following the existing Vyba design system: dark-first · strong visual hierarchy · brand
identity · no-line rule · high-quality imagery · fast perceived performance · clear
nightlife-oriented CTAs. **Polished enough to feel like a real product, not over-designed.**

**Owner app + admin dashboard:** functional and efficient — not the same visual investment.

**Principle:** polish the surfaces that influence user retention; optimize the surfaces used
by the operating team for speed.

---

## 18. Build team & timeline

### 18.1 Team

Target build team (do **not** assume a technical co-founder or additional members exist
unless confirmed):

- **1 full-stack / backend lead** — architecture, NestJS backend, domain model, API
  contracts, infrastructure, technical coordination. *(Yoboué currently fills this.)*
- **1 Flutter developer** — consumer app + minimal owner shell.
- **1 React developer** — lightweight QR/web surface + React admin dashboard.

**The 12–14 week target is conditional on these three capacities available in parallel.**
If the project becomes effectively solo:

1. extend the schedule toward **~5–6 months**, or
2. reduce MVP scope further.

Do not optimize for hitting a date at the expense of a valid validation cohort.

### 18.2 Budget

- **Hard budget ceiling for the ~4-month validation phase.** The specific operational
  number is not locked until SMS, printing and promoter costs are confirmed.
- Categories: development/contractors (largest variable) · hosting · SMS OTP + retries ·
  QR printing + physical materials · small promoter/DJ activation costs · essential
  analytics/operational tooling.
- If development is contracted: **fixed-price milestone-based delivery** against §19, not
  open-ended hourly.
- Promoters during validation: small fixed stipend when actively contributing · **no
  revenue share · no equity · no dedicated promoter product**. Boosted placement may become
  an incentive after the gate.

### 18.3 Sequencing

| Window | Work |
|---|---|
| **Weeks 1–4** — backend core | phone OTP + secure sessions · Venue · VenueNight · FeedItem · feed ranking · Going · Follow · Promotion · media upload · acquisition/attribution events · PostHog server-side proxy · notification infra. **Key API contracts progressively stabilized ~weeks 2–4.** |
| **Weeks 3–8** — parallel product dev | **Flutter:** feed · venue page · J'y vais · follow · notifications · minimal owner shell. **React:** lightweight QR/web surface · six-surface validation admin dashboard. Contract-first with mocks/stubs where appropriate; backend behaviour authoritative. |
| **Weeks 8–10** — hardening | consumer design pass · French-only UX/content pass · low-end Android testing · OTP/network testing · QR web performance · analytics/event verification · privacy/legal preparation · seed-content tooling. |
| **Weeks 10–12** — dogfood + physical onboarding | run the complete product internally (§21) **while beginning physical venue onboarding** (itself a 3–4 week effort — not serialized with the build). Do not wait for a "100% finished" product to approach venues. |
| **~Weeks 12–14** — cohort launch | open the first controlled Zone 4 cohort **only after the go/no-go checklist passes** (§20). |

API contracts stabilize progressively — no artificial single freeze date, but the core
contracts needed by Flutter / React web / Admin must be stable enough for parallel work by
**~week 3–4**.

---

## 19. Backend modules to build (weeks 1–4)

Mirror `modules/users/` conventions (controller `@Api*` decorators, service with typed
domain exceptions, DTOs with `class-validator`, entities extending `BaseEntity`).

- **`auth`** (rework) — phone + OTP, secure sessions, JWT access + refresh. Remove
  email/password + social from the primary path.
- **`venues`** — venue CRUD (admin/team-managed), Zone 4 boundary config, geo coordinates.
- **`venue-nights`** — `VenueNight` entity, live status + timestamp, night headline/DJ,
  per-night aggregates.
- **`feed`** — polymorphic `FeedItem`, server-side ranking endpoint, expiry handling,
  origin/`assisted` fields.
- **`going`** — mark/cancel, per-venue-night aggregate, abuse protection, feed-ranking signal feed.
- **`follows`** — user↔venue follow.
- **`promotions`** — promo CRUD tied to venue / venue-night.
- **`media`** — S3-compatible upload, venue photos (immediate) + user photos (curation queue).
- **`attribution`** — acquisition/landing event capture, structured params, raw event store.
- **`analytics-proxy`** — server-side PostHog proxy, PII minimization.
- **`notifications`** — FCM, the two recurring notifications, opt-in venue broadcasts + rate limiting.

---

## 20. Pre-cohort QA — formal launch gate

### 20.1 Low-end Android

Test on **real low-end devices** representative of the audience: 2–3 GB RAM · Tecno ·
Infinix · itel · weak/intermittent networks. Not emulator-only, not high-end-only.

Minimum test surface: cold start · login/OTP · feed loading · feed scrolling · images ·
venue page · J'y vais · map · background/resume behaviour · session persistence.

### 20.2 OTP

Structured tests across **Orange CI · MTN CI · Moov Africa CI**, measuring: delivery
success rate · latency · expiration · retry · duplicate-code · cost · failure reasons.

**Sustained delivery < ~90% on a materially important network ⇒ launch blocker /
investigation.** WhatsApp fallback only if operationally verified.

### 20.3 QR web

Full path: **QR → mobile web → venue page → J'y vais → OTP → confirmation**, under
throttled mobile conditions on low-end hardware.

Targets: meaningful venue content **< 1 s where realistically achievable**; **~2.5 s hard
ceiling** on the critical experience. Materially worse ⇒ fix before cohort launch (QR is a
core acquisition mechanism).

### 20.4 Go/no-go

The cohort opens only after a written go/no-go checklist passes. The objective is a
**controlled experiment with trustworthy data**, not a perfect launch.

---

## 21. Team dogfood — non-negotiable

**10 working days** before opening the cohort. The founding/technical team exercises the
entire loop daily:

**QR → web → OTP → J'y vais → app → feed → venue → follow → notifications**

Also simulate: multiple VenueNights · multiple users going · owner-created posts · assisted
posts · editorial posts · promotions · user photos · feed ranking changes · notification
delivery · attribution · PostHog events.

**Dogfood exit criteria:**

- Critical journeys work end-to-end
- Analytics events arrive correctly
- Attribution is preserved
- Sessions remain valid
- Empty states are intentional
- Going counts are correct
- Assisted content is correctly attributed
- QR attribution works
- No critical crashes/blockers remain

**A failed dogfood exit ⇒ delay cohort launch.** Do not contaminate the first retention
cohort with preventable technical problems. Dogfood exit is part of go/no-go (§20).

---

## 22. Operations

### 22.1 Venue onboarding kit — defined before the first onboarding session

1. **Venue QR kit** — venue-specific QR code; printed material with venue branding + Vyba
   branding + clear French CTA + QR + short benefit explanation. QR opens the venue's
   lightweight mobile-web page directly.
2. **Owner quick guide** — one page, French, one behaviour:
   **"Publiez votre actualité en 10 secondes."** Covers: access the owner app · mark the
   venue live · create a promotion · what content is useful · why regular updates matter.
   Not a software manual.
3. **Venue starter-content checklist** — every venue leaves onboarding with:
   - Venue profile completed
   - 3–5 quality photos
   - Initial venue update
   - First promotion (where applicable)
   - First live/tonight update
   - Owner trained
   - **First genuine owner-created post completed together**

   The objective is not "the owner has an account" — it is *"the owner has successfully
   performed the behaviour we need them to repeat."*

### 22.2 Editorial cadence

Simple weekday editorial calendar, ~4 repeatable formats:

- **Ce soir à Zone 4**
- **5 spots chauds ce soir**
- **Le week-end arrive**
- **Focus soirée / DJ**

Lightweight enough to execute consistently. Not a full media operation.

### 22.3 Content/community operations owner

**Exactly one accountable person** owns content/community operations during validation
(a founder initially — not necessarily a full-time hire). Responsible for: venue onboarding
coordination · starter content · editorial calendar · photo curation · venue activity
monitoring · inactive-venue follow-up · qualitative feedback collection.

**If this responsibility has no owner, it is an operational gap that must be resolved before
the validation cohort begins.**

### 22.4 Support & qualitative feedback

- **WhatsApp Business** is the primary support channel for both users and owners. No full
  in-app support system for a 500-user cohort.
- App provides a lightweight **"Un problème ?" → WhatsApp**.
- Maintain a lightweight qualitative log, categorized: signup/OTP · discovery/feed · venue
  info · going · notification · performance · owner posting · feature request · user
  expectation · venue operational problem.
- Qualitative validation: ~**5 short user interviews per month** · regular conversations
  with inactive/quiet venues · **record the reason when a venue stops posting** ·
  distinguish product problems from operational/content problems.
- Qualitative findings reviewed **alongside** the quantitative dashboard in the **weekly
  validation meeting** — answering not just *"are the metrics good?"* but *"why?"*.

---

## 23. Validation gates & pre-committed decision rule

### 23.1 Timeline

Validation phase runs ~**3–4 months**.

### 23.2 Metric definitions (locked — cannot be reinterpreted at review time)

**Active user:** performs **≥ 1 meaningful action in a rolling 7-day window**. A bare app
open does not count. Meaningful actions: meaningful feed interaction/depth · venue view ·
"J'y vais" · follow a venue · other explicitly defined core discovery action. Implemented
consistently in PostHog and the validation dashboard.

**Zone 4 active user** (for the KPI — based on actual Zone 4 activity, **not live GPS**):
qualifies when they (1) perform a meaningful action involving a Zone 4 venue, **or**
(2) mark "J'y vais" for a Zone 4 venue.

`acquisition_zone` (where they came from) and `active_zone` (whether they engaged with
Zone 4) are **separate** — acquisition attribution is never treated as proof of ongoing
engagement.

**Zone 4 boundary:** the Zone 4 / Marcory validation polygon is **locked in backend
configuration before launch**. Every backend query, analytics event and dashboard
calculation uses the same canonical boundary. Live GPS is not the primary definition.

### 23.3 Validation gate (PASS target)

Sustained for **≥ 1 month**, within the 3–4 month window:

- ≈ **500 weekly active users** in the launch area
- **≥ 25% week-4 retention**
- **≥ 15 of ~30** onboarded venues posting **organically every week**
- Meaningful "going" activity across most weekend nights

The venue-posting metric is particularly important: the goal is to progressively reduce
founder-assisted content. If venues only post when the team creates content for them, the
product is **not** validated.

The numbers are **validation gates, not proof of product-market fit** — used to decide
whether to expand, iterate, narrow, or pivot.

### 23.4 Pre-committed decision rule (month-4 review = a lookup, not a debate)

**PASS** — all gates achieved and sustained ~1 month; healthy retention; meaningful Zone 4
activity; sustained organic venue posting.
→ **Do not immediately expand geographically.** First spend **~4–6 weeks testing
monetization** with the existing ~30 venues: activate v1 paid boosts, measure willingness
to pay · conversion to paid placement · price sensitivity · repeat purchase · perceived ROI.
Only after a meaningful revenue signal, consider expanding beyond Zone 4.
Sequence: **validate engagement → validate organic supply → validate monetization → expand.**

**PARTIAL** — one half of the marketplace works (users retain but venues don't post
organically; or venues post but users don't return).
→ **Do not expand geographically.** Spend **~6–8 weeks fixing the failed side** with the
same cohort and same wedge, then reassess against the same gates.
- Users retain, venues don't post → improve owner value visibility · improve posting UX ·
  test amplification mechanisms · interview inactive venues · test whether the problem is
  value, friction or venue segment.
- Venues post, users don't return → improve feed relevance · improve discovery · improve
  content density · investigate whether *"qu'est-ce qui se passe ce soir ?"* actually
  creates a recurring habit.

**FAIL** — week-4 retention remains **below ~15%**, going activity negligible, results poor
after ~4 months.
→ Treat the weekly-nightlife-feed thesis as **invalidated**. **Do not simply shrink the
geographic wedge — a smaller dead feed is still a dead feed.** Evaluate a deliberate pivot
on the evidence collected:
1. **Venue directory + J'y vais utility** — drop the assumption that the feed itself becomes
   a recurring habit; retain discovery + intent.
2. **B2B venue promotion tool** — consumer experience becomes the distribution layer; value
   proposition shifts toward venue acquisition/promotion.
3. **Soirée / event ticketing** — shift the core transaction from discovery/intent toward
   event monetization.

### 23.5 Pre-commitment principle

> **Vyba will not use additional founder effort, geographic expansion, or feature expansion
> to hide a failed validation signal.**

The validation timeline is conditional on **team capacity**. The validation *quality* is
conditional on the **QA / dogfood gates**.

---

## 24. Immediate next step

1. This spec is approved.
2. Audit the existing codebase against it — `EXISTS → MODIFY → BUILD → DELETE → DEFER` — see
   `VYBA_CODEBASE_AUDIT.md`.
3. Do **not** begin implementing remaining modules before the audit is reviewed.
