# Spec: follows

> Ready-for-agent spec. Vyba validation MVP (unit 5).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §8, §19; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

A client who likes a venue wants to keep up with it — its promos, its events, its
"live tonight" — without relying on the general Zone 4 feed to surface it. The old
product idea called this "favourites"; the validation product has one concept:
**Follow**. Following must actually change the feed (followed venues get a lift, per
the feed unit) and is the basis for venue-specific notifications later.

The backend has no follow concept. The mobile app has a `favorites` feature (mock)
that is being folded into this.

## Solution

A client can follow and unfollow a venue. The set of a client's followed venues is
readable (for their profile and for the feed ranking's follow-lift), and a venue's
follower count is readable (for the venue view and the team's monitoring). Nothing
about following requires venue or team action.

## User Stories

1. As a client, I want to follow a venue from its page, so that I can keep track of it.
2. As a client, I want to unfollow a venue, so that I can stop tracking one I've lost interest in.
3. As a client, I want my followed venues' content to be more prominent in my feed, so that following is meaningful.
4. As a client, I want to see the list of venues I follow, so that I can manage them from my profile.
5. As a client, I want following to be instant and silent, so that it's a low-stakes action.
6. As a client, I want following to be idempotent, so that tapping twice doesn't error or double-count.
7. As a venue owner, I want to see how many people follow my venue, so that I have a sense of my audience (part of the owner-home value stats).
8. As the Vyba team, I want follower counts per venue, so that I can see which venues are gaining an audience during validation.
9. As a developer, I want a cheap "does user X follow venue Y" and "venues followed by user X" lookup, so that the feed ranking endpoint can use it per request.
10. As a developer, I want follow state scoped to real users and active venues, so that stale rows don't accumulate.
11. As a platform operator, I want follow and unfollow events recorded with timestamps, so that follow growth is measurable.

## Implementation Decisions

**Module**

- New `follows` module — a `Follow` record + follow/unfollow endpoints + read
  endpoints.

**`Follow` entity**

- `id`, `userId`, `venueId`, `createdAt`. Unique on `(userId, venueId)` for active
  rows.
- Unfollow: hard-delete the row, or soft-delete with `unfollowedAt` — soft-delete
  preferred so unfollow events remain measurable (platform-operator story 11).
- If soft-deleted, re-following the same venue reactivates / inserts and there is
  still at most one active row per pair.

**Endpoints (shape)**

- Client: follow(venueId), unfollow(venueId) — both idempotent; list my followed
  venues.
- Public/derived: venue follower count (exposed on the venue detail payload from the
  `venues` unit — this unit provides the count query).
- Internal: `followedVenueIds(userId)` and `isFollowing(userId, venueId)` for the
  `feed` ranking endpoint.

**Authorization**

- Follow / unfollow / list-own: any authenticated `CLIENT`.
- Follower count: visible to the venue's owner and `ADMIN`; the raw count can also
  appear on the public venue payload (not the follower identities).

**Events**

- Emit `venue_followed` / `venue_unfollowed` analytics events (the
  attribution-and-analytics unit defines the taxonomy; this unit fires them).

## Testing Decisions

**Good test:** drives follow/unfollow over HTTP and asserts the observable results —
my followed list contains the venue after follow and not after unfollow; following
twice is a no-op not an error; follower count reflects follows/unfollows; a client
cannot see another client's followed list.

**Seam:** backend HTTP API (unit-1 e2e seam). Reuse the auth helper and unit 2's
venues.

**Modules under test:** `follows`, with the follower count observed via the venue
detail payload.

**Prior art:** units 1–4 e2e specs; `docs/backend.md` conventions.

**Representative cases:** follow → in my list, count +1; follow again → still one,
count unchanged; unfollow → out of my list, count −1; re-follow → back, still one
active row; `followedVenueIds` returns the right set for the feed unit.

## Out of Scope

- The feed's use of follow state (feed unit already specs the lift).
- Venue-specific notification opt-in and broadcasts (notifications unit) — following
  a venue is not the same as opting into its broadcasts.
- "People you follow are going" social features.
- The mobile/web follow button UI (client units).
- Migrating any existing `favorites` mock data (there is none real).

## Further Notes

- `CONTEXT.md` states Follow "absorbs the older favourites idea" — there is one
  concept, named Follow, everywhere.
- Following ≠ broadcast opt-in: the notifications unit will have its own per-venue
  opt-in (MVP spec §12).
