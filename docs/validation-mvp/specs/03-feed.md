# Spec: feed

> Ready-for-agent spec. Vyba validation MVP critical path (unit 3 of 4).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §3, §9.2, §19; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The feed is Vyba's core loop — the thing that makes someone open the app on a
Wednesday to see what's happening this weekend, and the surface a boost is later
sold against. It has to answer *"qu'est-ce qui se passe à Zone 4 ce soir ?"* better
than a generic social network. It must stay useful on quiet weeknights with only a
handful of venue posts, rank tonight's content above everything else, and never
show yesterday's event as if it were current.

It also carries a measurement burden: whether a piece of venue content was created
by the venue itself or with Vyba team help (`assisted`) is one of the core
validation signals, and it must be recorded truthfully — not left to whoever builds
the admin UI.

The backend has no feed. The mobile feed entity models only "promo" and "event" and
is mock-only.

## Solution

A single **`FeedItem`** entity, polymorphic by `type`, covering venue updates,
one-tap "live tonight" posts, promotions, events, Vyba editorial, going milestones,
and photos. One server-side **ranking endpoint** returns the Zone 4 feed in
display order at request time: tonight first, then this weekend, upcoming, recent,
evergreen — with an activity boost from the "going" count and a recency decay.
Time-bound items expire the morning after their date and drop out.

Every item records who created it, its origin (venue / founder / founder-assisted /
user), and an `assisted` boolean — set by the backend from the authenticated
principal and the creation path, never trusted from the client.

## User Stories

1. As a client, I want to open the app and see a single Zone 4 feed of what's happening, so that I don't have to hunt venue by venue.
2. As a client, I want tonight's content ranked above content for later in the week, so that the top of the feed is immediately useful when I'm deciding where to go now.
3. As a client, I want this weekend's content above next week's, so that near-term plans surface first.
4. As a client, I want busier venues (more people going tonight) to rank a little higher, so that the feed reflects where things are actually happening.
5. As a client, I want an event that already happened to disappear from the feed the next morning, so that the feed is never stale.
6. As a client on a quiet Tuesday, I want to still see upcoming events, promos and editorial, so that the app is worth opening mid-week.
7. As a client, I want a venue's one-tap "on est live ce soir" to show up as a real feed item, so that low-effort venue signals still tell me something.
8. As a client, I want to see going activity and curated photos in the feed, so that it has a pulse even when venues haven't posted.
9. As a client following specific venues, I want their content reliably present in my feed, so that following means something.
10. As a venue owner, I want to post a quick venue update (text + optional photo) in seconds, so that keeping my venue visible is not a chore.
11. As a venue owner, I want to create a promotion that appears in the feed and on my venue page, so that an offer reaches people deciding tonight.
12. As a venue owner, I want to announce an event with a date, so that people can plan and mark that they're going.
13. As a venue owner, I want my own posts recorded as venue-created (not assisted), so that my genuine activity is counted as organic.
14. As the Vyba team, I want to publish an editorial item ("Ce soir à Zone 4", "5 spots chauds ce soir") with a publish time and an expiry, so that the feed stays full on slow nights.
15. As the Vyba team, I want to create a promo or update on behalf of a venue and have it automatically recorded as founder-assisted, so that the organic-vs-assisted metric is accurate without me remembering to flag it.
16. As the Vyba team, I want user-submitted photos to only enter the main feed when we promote them, so that feed quality stays high.
17. As the Vyba team, I want to hide or remove a feed item, so that bad content can be pulled quickly.
18. As a platform operator, I want a `going_milestone` item generated when a venue crosses an attendance threshold tonight, so that momentum is visible in the feed.
19. As a platform operator, I want every feed item to carry created-by, origin, assisted, timestamps and type, so that content activity can be analysed.
20. As a developer, I want ranking computed at request time from a small candidate set, so that there are no per-user precomputed feed tables to maintain.
21. As a developer, I want the feed scoped to the launch area, so that ranking never has to consider out-of-area venues.
22. As a developer, I want expiry handled consistently (an expired item is never returned, regardless of a cleanup job's timing), so that correctness doesn't depend on a cron.
23. As a reviewer, I want `assisted` set server-side from the principal and creation path, so that a client cannot post assisted content as organic.
24. As a client, I want the feed to render in the order the server returns, so that the experience is consistent across app and web.

## Implementation Decisions

**Module**

- New `feed` module — `FeedItem` entity, creation endpoints per source, the ranking
  read endpoint, admin moderation endpoints.

**`FeedItem` entity**

- `id`, `type` ∈ { `venue_update`, `live_tonight`, `promo`, `event`, `editorial`,
  `going_milestone`, `photo` }.
- Associations: `venueId` (nullable — editorial may be area-wide), `venueNightId`
  (nullable — set for tonight-scoped items).
- Provenance: `createdByUserId`, `origin` ∈ { `venue`, `founder`,
  `founder_assisted`, `user` }, `assisted` (bool; `true` iff `origin =
  founder_assisted`).
- Timing: `startsAt` (nullable — event/promo start), `expiresAt` (required for
  time-bound types; derived, see below), `publishedAt`, `createdAt`, `updatedAt`.
- State: `status` ∈ { `draft`, `published`, `hidden`, `expired` }.
- `payload` — a typed JSON blob for type-specific fields (e.g. promo: title,
  description, image ref, promo kind; event: title, date, image ref; venue_update:
  text, optional image ref; editorial: title, body). Validated per type on write.

**Origin / `assisted` rule (enforced server-side)**

- Venue owner (principal role `VENUE_OWNER`, owns the target venue) creates content
  → `origin = venue`, `assisted = false`.
- Vyba team (`ADMIN`) creates content for a venue via the assist path → `origin =
  founder_assisted`, `assisted = true`, `createdByUserId` = the team member.
- Vyba team creates editorial → `origin = founder`, `assisted = false`.
- User creates a photo → `origin = user`; not `published` until promoted.
- There is **no client-supplied `origin`/`assisted` field**. The value is a function
  of (authenticated principal, endpoint used, target venue ownership).

**Expiry**

- Time-bound types (`live_tonight`, `event`, `promo` with an end, `going_milestone`)
  get an `expiresAt` computed on creation — for tonight-scoped items, the morning
  after the `VenueNight` date (recommended 06:00 Abidjan).
- The ranking query filters `status = published AND (expiresAt IS NULL OR expiresAt
  > now())`. A nightly job flips lapsed items to `status = expired` for tidiness and
  analytics, but **correctness does not depend on it** — the read filter is
  authoritative.

**Ranking endpoint**

- Input: authenticated client (for follow-awareness), optional paging.
- Candidate set: published, non-expired `FeedItem`s for active launch-area venues +
  area-wide editorial. Small by design (~tens/day, MVP spec §3.4).
- Score = tier rank + boost + decay:
  - Tier: `tonight` (item's `venueNightId` is today, or `startsAt` is today) >
    `this_weekend` (Thu–Sun of the current week, future) > `upcoming` (later) >
    `recent` (published in last ~48h, no future relevance) > `evergreen`.
  - Boost: a bounded increment from the associated `VenueNight.goingCount` (so busy
    venues rise; capped so it can't override the tier).
  - Decay: recency within a tier.
  - Followed-venue items get a small, bounded lift — enough to satisfy "following
    means something" without turning the feed into a pure follow list.
- Output: an ordered list the client renders as-is. No client re-sorting.
- Keep the formula simple and in one place; it is expected to change once real
  engagement data exists.

**Going milestones**

- The `going` unit (unit 4) calls into `feed` to emit a `going_milestone` item when
  a `VenueNight` crosses a threshold (e.g. 10 / 25 / 50). `feed` owns the item
  shape; `going` owns the trigger. One milestone item per threshold per venue-night.

**Moderation**

- `ADMIN` can `hide` (reversible) or hard-delete any item, and `promote` a `user`
  photo from `draft` to `published`.

**Authorization**

- Create venue content: `VENUE_OWNER` (own venue) or `ADMIN` (assist).
- Create editorial / promote photos / moderate: `ADMIN`.
- Read the feed:
  - **Authenticated** (`CLIENT`) — the app's Zone 4 feed, follow-aware.
  - **Unauthenticated public read** — a separate, read-only, rate-limited endpoint
    for the QR web surface: the Zone 4 feed with public, PII-free item fields only,
    not follow-aware. No mutations. Must not widen the authenticated payload or
    weaken existing authorization. Abuse-monitored.

## Testing Decisions

**Good test:** drives the ranking endpoint and the creation endpoints over HTTP and
asserts the order and membership of the returned feed, and the recorded provenance
of created items. It seeds `VenueNight`s with known going counts and items with
known dates, then asserts "tonight's live item is above next Friday's event",
"yesterday's event is absent", "the assist endpoint produced `assisted = true`". It
does not test the scoring function in isolation or assert on score numbers — only on
resulting order.

**Seam:** backend HTTP API (the unit-1 e2e seam). Reuse the auth helper and unit
2's venue/venue-night creation to build fixtures.

**Modules under test:** `feed`, with `venues`/`venue-nights` as fixture support.

**Prior art:** units 1–2 e2e specs; `docs/backend.md` conventions.

**Representative cases:** owner posts update → appears in feed, `origin = venue`,
`assisted = false`; team posts promo via assist path for a venue → `origin =
founder_assisted`, `assisted = true`; two venues live tonight, one with higher going
count → higher-going venue ranks above; an event dated yesterday → not returned even
before the cleanup job runs; editorial with future `publishedAt` → not returned yet;
`hidden` item → not returned; user photo → not in feed until `ADMIN` promotes it;
followed venue's item gets a lift but a much-busier non-followed venue can still
outrank it.

## Out of Scope

- Boosts / paid placement in the feed (post-validation).
- Per-user precomputed feeds, real-time feed updates, push-on-new-item.
- The mobile/web feed UI and rendering (their own units).
- Photo upload and the curation queue mechanics (media unit) — this unit consumes
  photo refs and the promote action.
- Comments, likes, reactions, sharing.
- Reviews (deferred).
- Notification generation from feed items (notifications unit).

## Further Notes

- The `assisted` invariant is in `Vyba-backend/CONTEXT.md` and the MVP spec §9.2 —
  it is load-bearing for the month-4 validation decision, so the server-side
  enforcement is not optional.
- Ranking is intentionally naive; resist adding relevance signals beyond
  tier/boost/decay/follow until data asks for them (MVP spec §3.3).
- Feed density targets and the editorial cadence are operational (MVP spec §3.4,
  §22.2), not part of this unit — but the editorial creation endpoint this unit
  provides is what makes that cadence possible.
