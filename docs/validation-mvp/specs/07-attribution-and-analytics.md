# Spec: attribution-and-analytics

> Ready-for-agent spec. Vyba validation MVP (unit 7).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §11, §23.2, §19; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The whole point of the validation phase is to answer measurable questions: how many
people are active in Zone 4, do they come back next week, which acquisition channel
produces retained users, do venues post organically. None of that can be answered
after the fact — the instrumentation has to exist before the first cohort. Today
there is no analytics, no attribution, no event taxonomy, and the backend must not
leak phone numbers into a third-party analytics tool.

## Solution

Two mechanisms. **Attribution**: every entry point (venue QR, promoter link, social
campaign) carries structured parameters; the backend records raw landing and signup
events with those parameters and snapshots the acquisition source onto the user at
creation — without collapsing multi-touch history. **Analytics**: a defined event
taxonomy is emitted to PostHog through a server-side proxy that minimises PII
(internal ids, never phone numbers), so retention cohorts, funnels and
source-segmented analysis are possible.

The launch-area boundary is one canonical polygon; `acquisition_zone` (where a user
came from) and `active_zone` (whether they engage with Zone 4) are tracked
separately and never conflated.

## User Stories

1. As the Vyba team, I want every venue's QR code to carry that venue's id, so that I can see which venues drive signups.
2. As the Vyba team, I want each seeded promoter to have a unique link, so that I can compare promoters.
3. As the Vyba team, I want each social campaign to have a distinct identifier, so that I can compare social to QR.
4. As a platform operator, I want a raw landing event stored when someone opens a QR/campaign link, so that I can measure link → app funnel drop-off.
5. As a platform operator, I want the acquisition source recorded on the user at signup, so that I can segment retention by where they came from.
6. As a platform operator, I want the full acquisition/landing history kept, not just the first or last touch, so that multi-channel journeys aren't lost.
7. As a platform operator, I want `acquisition_zone` and `active_zone` as separate fields, so that "came from a Zone 4 QR" is never mistaken for "engages with Zone 4".
8. As a platform operator, I want a user counted as a Zone 4 active user only when they take a meaningful action involving a Zone 4 venue or mark "J'y vais" there, so that the WAU gate is honest.
9. As a platform operator, I want "meaningful action" defined once and applied consistently in PostHog and in first-party queries, so that the two never disagree.
10. As a platform operator, I want week-1 / week-2 / week-4 retention cohorts by acquisition source, so that I know which channel produces retained users.
11. As a platform operator, I want QR → signup and promoter → signup conversion rates, so that I can judge channel efficiency.
12. As a platform operator, I want going rate by source, so that I can see which channel brings people who actually act.
13. As a platform operator, I want organic vs founder-assisted posting counts per venue per week from first-party data, so that the central validation gate is measurable.
14. As a security reviewer, I want no phone numbers, OTP codes or tokens sent to PostHog, so that analytics is not a PII sink.
15. As a security reviewer, I want analytics traffic to go through a server-side proxy, so that the client can't be pointed at analytics with arbitrary payloads and keys aren't exposed.
16. As a developer, I want a small, named set of events with a stable schema, so that instrumentation across app, web and backend is consistent.
17. As a developer, I want to emit an event from any module (backend) or from the clients via the proxy, so that instrumentation isn't centralised in one place.
18. As the Vyba team, I want the canonical Zone 4 polygon to be the same one the `venues` unit uses, so that there's one definition of the launch area.

## Implementation Decisions

**Modules**

- New `attribution` module — structured-param capture, raw `LandingEvent` /
  `AcquisitionEvent` store, user acquisition snapshot on signup.
- New `analytics-proxy` module — a server-side endpoint the clients call to emit
  events; forwards to PostHog with PII stripped; the backend also emits server-side
  events directly.
- Shared config — the Zone 4 polygon (shared with `venues`, unit 2) and the
  meaningful-action definition (a constant/list referenced by both the proxy and
  first-party queries).

**Attribution parameters**

- Link shapes: `?src=qr&venue=<venueId>`, `?src=promoter&pid=<promoterId>`,
  `?src=social&campaign=<campaignId>` (and a generic fallback).
- Promoters are tagged normal user accounts (MVP spec §11.4) — `promoterId` is just
  a user id with a promoter tag; no promoter entity.
- The web surface and app capture these on first load / install and send them with
  the landing event and, later, the signup.

**Raw event store**

- `LandingEvent`: `id`, `src`, `venueId?`, `promoterId?`, `campaignId?`, `surface`
  (web/app), anonymous client id, `createdAt`. No user id yet (pre-signup).
- On signup (unit 1's verify), the pending attribution (matched via the anonymous
  client id) is recorded as an `AcquisitionEvent` tied to the user and a snapshot is
  written to `User`: `acquisitionSource`, `acquisitionVenueId?`,
  `acquisitionPromoterId?`, `acquisitionCampaignId?`, `acquisitionZone`,
  `firstLandingAt`, `signupAt`.
- **Raw events are retained** — the `User` snapshot is a convenience, not the record
  of truth. Multi-touch history lives in `LandingEvent` / `AcquisitionEvent`.

**`active_zone`**

- Set/updated when a user takes a meaningful action involving a launch-area venue or
  marks "J'y vais" there. Stored on `User` (`activeZone`) and also derivable from
  events. This is what the WAU gate counts, not `acquisitionZone`.

**Event taxonomy (initial — refinable, schema stable)**

`feed_opened`, `feed_item_viewed`, `venue_viewed`, `venue_followed`,
`going_marked`, `going_cancelled`, `promo_viewed`, `promo_created`,
`event_viewed`, `post_created`, `post_created_organically`,
`post_created_founder_assisted`, `qr_landing_opened`, `app_install_started`.

- Each event: a name, a timestamp, an internal user id (or anonymous client id
  pre-signup), and a small typed property bag (e.g. `venue_id`, `venue_night_id`,
  `source`). **Never** a phone number.
- `post_created_organically` / `post_created_founder_assisted` are emitted by the
  `feed` module from the `assisted` value — the first-party `FeedItem` table is the
  source of truth for the organic/assisted gate; the events mirror it for PostHog
  funnels.

**PostHog proxy**

- Clients POST events to the backend proxy; the proxy validates the event against
  the taxonomy, attaches the server-known internal user id, strips/omits anything
  not in the allowed property set, and forwards to PostHog (EU-hosted project).
- PostHog API keys live server-side only.
- Backend modules emit directly through the same forwarding path.

**First-party metrics support**

- Provide the queries / views the dashboard's "Validation metrics" surface needs
  (unit: dashboard-cockpit): Zone 4 WAU (meaningful action in rolling 7 days,
  `activeZone = zone_4`), organic vs assisted posts per venue per week, going
  activity per night, active venues, content activity. These read `FeedItem`,
  `Going`, events — first-party, not PostHog.

**Meaningful-action definition (locked)**

- Meaningful action = one of: `feed_item_viewed` past a depth threshold /
  `venue_viewed` / `going_marked` / `venue_followed` / a defined discovery action.
  Codified once; both the proxy (for `active`/`activeZone` derivation) and the
  first-party WAU query use the same list.

## Testing Decisions

**Good test:** drives landing → signup → actions over HTTP and asserts the recorded
attribution and the derived fields — a signup after a `src=qr&venue=X` landing has
`acquisitionSource = qr`, `acquisitionVenueId = X`, `acquisitionZone = zone_4`, and
`activeZone` unset until a Zone 4 action; forwarded analytics payloads (captured by a
fake PostHog client) contain an internal id and never a phone number; raw
`LandingEvent`s are still queryable after the snapshot is written.

**Seam:** backend HTTP API (unit-1 e2e seam) plus a **fake PostHog client** injected
into the proxy that records forwarded payloads for assertion. Reuse units 1–4.

**Modules under test:** `attribution` and `analytics-proxy` through the API; `feed`
observed for the `post_created_*` events.

**Prior art:** units 1–6 e2e specs; `docs/backend.md`.

**Representative cases:** QR landing then signup → correct acquisition snapshot +
raw events retained; promoter landing → `acquisitionPromoterId` set; two landings
from different sources before signup → both raw events kept, snapshot is a defined
choice (first-touch recommended, documented); Zone 4 `venue_viewed` → `activeZone`
becomes `zone_4`; proxy rejects an unknown event name; proxy strips a `phone`
property if a client sends one; assisted post → `post_created_founder_assisted`
forwarded; first-party "organic posts this week for venue X" query matches the
`FeedItem` rows.

## Out of Scope

- The PostHog project setup, EU hosting choice, dashboards built inside PostHog (ops
  / MVP spec §11.1).
- The QR code generation and print kit (ops / MVP spec §22.1).
- Client-side capture UI/SDK wiring (client units) — this unit defines the proxy
  contract and taxonomy they call.
- The dashboard metrics screen itself (dashboard-cockpit unit) — this unit provides
  the queries.
- Crash reporting.
- Consent management UI (privacy unit / client units) — this unit must be
  compatible with "analytics only with notice", i.e. not emit before the client
  says it may.

## Further Notes

- The `acquisition_zone` vs `active_zone` separation is an invariant
  (`Vyba-backend/CONTEXT.md`, MVP spec §23.2). Conflating them would corrupt the
  headline gate.
- The `FeedItem` table — not PostHog — is authoritative for the organic/assisted
  gate; PostHog is for funnels and cohorts.
- Multi-touch attribution snapshot policy (first-touch vs last-touch) should be
  confirmed in review; first-touch is the recommended default and what the tests
  assume.
