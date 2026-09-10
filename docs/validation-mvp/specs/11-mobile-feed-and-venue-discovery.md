# Spec: mobile-feed-and-venue-discovery

> Ready-for-agent spec. Vyba validation MVP critical path (unit 11). Depends on 09, 10, and backend 02–05.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §3, §6.1, §8, §17; `docs/adr/0001`; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The feed is the reason a user opens Vyba on a Wednesday, and the venue page is where
they decide to go. These are the surfaces the whole validation retention signal
rides on, so they must feel like a real nightlife product — not a template list
view. The app currently has a mock feed that models only "promo" and "event", a
venue detail page with the wrong model, and no map.

## Solution

Rebuild the feed to render the backend's polymorphic `FeedItem` stream in the order
the server returns (no client re-ranking), with a distinct card per type. Rebuild
the venue page around durable profile + tonight's `VenueNight` state (live, headline,
going count). Add Explore: a Google Maps view of Zone 4 venues plus a filterable
list. These four things (feed, venue page, and — from unit 12 — the "J'y vais" flow
and the sibling QR web page) get a deliberate design pass against the Vyba design
system.

## User Stories

1. As a client, I want to open the app to a single Zone 4 feed, so that I immediately see what's happening.
2. As a client, I want tonight's items at the top, then this weekend, then upcoming, so that the most relevant things come first — in the order the server decided.
3. As a client, I want each feed item type to look distinct (a live-now card, a promo, an event, an editorial note, a going milestone, a photo), so that I can scan quickly.
4. As a client, I want to pull to refresh the feed, so that I can get the latest before heading out.
5. As a client, I want the feed to page as I scroll, so that it stays fast.
6. As a client, I want a feed item to link to its venue, so that I can go from "that looks good" to deciding.
7. As a client, I want an intentional empty state when the feed is genuinely quiet, so that it feels considered, not broken.
8. As a client, I want the feed to render from a cache when I open the app with no connection, so that it's not a blank screen on the metro.
9. As a client, I want to open a venue and see its photos, description, type, address, and tonight's state (live or not, headline, how many are going) in one view, so that I can decide fast.
10. As a client, I want a venue with nothing on tonight to still show its profile clearly, so that I know what it is.
11. As a client, I want to open the venue's location in Google Maps, so that I can get there.
12. As a client, I want an Explore map of Zone 4 venues, so that I can see what's around me spatially.
13. As a client, I want the map styled to match the app (dark), so that it doesn't feel bolted on.
14. As a client, I want a venue list I can filter by type (club / bar / lounge / maquis), so that I can narrow down without a search box.
15. As a client, I want feed and venue screens that look like a nightlife product — strong imagery, dark surfaces, no hairline borders, clear CTAs — so that the app feels worth returning to.
16. As a developer, I want the feed to render server order verbatim, so that ranking stays a backend concern.
17. As a developer, I want feed/venue state as Freezed sealed unions behind Riverpod notifiers, so that loading/loaded/error/empty are explicit.
18. As a platform operator, I want `feed_opened`, `feed_item_viewed`, `venue_viewed` events emitted, so that engagement and the "meaningful action" / `active_zone` derivation work.
19. As a client, I want images to load progressively and at sensible sizes, so that a low-end phone on a weak connection copes.

## Implementation Decisions

**Modules touched**

- `features/feed` — replace the entity with a polymorphic `FeedItem` mirroring the
  backend (a sealed class or a single class + `type` + typed payload; match the
  backend types: `venue_update`, `live_tonight`, `promo`, `event`, `editorial`,
  `going_milestone`, `photo`). Real remote datasource. Notifier renders the server
  list; paging; pull-to-refresh; last-feed read cache.
- `features/venues` — real remote datasource; venue detail = profile + today's
  `VenueNight` payload from the backend; venue list with a type filter; Explore map.
- `core` — Google Maps SDK dependency + a dark map style; an image caching/config
  choice; the read cache for feed + venue list (a simple persisted last-response,
  not a sync engine).

**Feed rendering**

- One card widget per `FeedItem` type. `live_tonight` and `going_milestone` cards
  emphasise "now"; `event` shows the date and a "J'y vais" affordance (action itself
  is unit 12); `editorial` is visually lighter; `photo` is image-forward.
- The list is exactly the server's order. The client may group by the server's tier
  label if the API returns one, but must not reorder within or across tiers.
- Empty state: a designed "c'est calme ce soir à Zone 4" with upcoming items if any.
- Offline: render the cached list with a subtle "hors ligne" indicator; refresh on
  reconnect.

**Venue detail**

- Header: hero photos. Body: type, price indicator (FCFA), description, address +
  "Ouvrir dans Google Maps". Tonight block: live status + `liveSince` relative time
  + headline/DJ + "X personnes y vont ce soir" (count from the backend). If no
  `VenueNight` today: a clear "rien d'annoncé ce soir" state.
- Follow button (action is unit 12; the button lives here).
- "J'y vais" button (action is unit 12; button lives here).

**Explore**

- Google Maps centred on Zone 4 with venue pins (active venues in the launch area).
  Tapping a pin → a compact venue card → venue detail.
- A toggle or tab to the filterable list (same data, list form).
- The map is a conversion surface, not the home screen — Explore is a tab, the feed
  is the default.

**Design pass**

- Feed, venue detail, and the Explore surfaces are built with the `frontend-design`
  skill and reviewed with `ui-ux-pro-max` (per `CLAUDE.md`). Dark-first, no-line
  rule, project tokens, brand colours semantic. This is explicit scope, not polish
  to be skipped.

**Analytics**

- Emit `feed_opened` on feed view, `feed_item_viewed` past a visibility threshold,
  `venue_viewed` on venue detail, `event_viewed` / `promo_viewed` as applicable —
  via the analytics client (unit 07 contract). A Zone 4 `venue_viewed` is what flips
  `active_zone`.

## Testing Decisions

**Good test:** drives the feed and venue notifiers with a fake datasource returning
canned backend payloads and asserts the observable state — the feed notifier exposes
items in the received order, pull-to-refresh triggers a refetch, an empty payload
yields the empty state, a network error with a warm cache yields the cached list +
offline flag. Widget tests render the feed list (asserting a live card vs an event
card render differently and in order) and the venue page (asserting the "rien
d'annoncé" state when no `VenueNight`, and the going count when present).

**Seam:** the **notifier ↔ use case** boundary with fake datasources, plus
screen-level widget tests for the feed list and venue detail. Map interaction is
smoke-tested only (pin tap → navigation intent).

**Modules under test:** `features/feed`, `features/venues`.

**Prior art:** existing `features/venues` notifier/state tests; `docs/mobile.md`
layer contracts and the Freezed sealed-union state convention.

**Representative cases:** server returns [live A, event B (Fri), editorial C] → list
renders in that order; refresh → datasource called again; empty → empty state;
error + cache → cached list + "hors ligne"; venue with today's `VenueNight` (live,
count 14) → tonight block shows live + "14 personnes y vont ce soir"; venue with no
`VenueNight` → "rien d'annoncé ce soir"; type filter = maquis → only maquis in the
list.

## Out of Scope

- The "J'y vais" and follow *actions* (unit 12) — buttons render here, wiring is
  there.
- Feed ranking logic (backend unit 03).
- Push notifications and deep-link routing (unit 10).
- Photo *upload* (unit 12 for user night-photos).
- The owner shell (unit 13).
- Reviews UI (deferred).
- Turn-by-turn directions (just "open in Maps").

## Further Notes

- ADR-0001: tonight's state comes from `VenueNight`, so the venue page must handle
  "no VenueNight today" as a first-class state, not an error.
- Server order is authoritative — resist any client-side "smart" reordering
  (`Vyba-mobile-app/CONTEXT.md` invariant).
- This unit + unit 12 + the QR web page (unit 14) are the design-investment
  surfaces; the owner shell and dashboard are not.
