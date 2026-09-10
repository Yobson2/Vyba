# 07: Zone 4 feed — live + editorial, ranked and expiring

**What to build:** A client opens the app to a single Zone 4 feed. A venue that's
live tonight shows a `live_tonight` card at the top; team `editorial` items sit
below by tier; an item whose date has passed is gone. The feed renders exactly the
order the server returns.

**Blocked by:** 06 (owner live tonight).

**Specs:** `../specs/03-feed.md`, `../specs/11-mobile-feed-and-venue-discovery.md`; `../../adr/0001-venuenight-as-temporal-spine.md`.
**Seam:** backend HTTP e2e (assert order + membership); mobile notifier↔usecase +
a feed-list widget test.

**Status:** ready-for-agent

- [ ] Backend: polymorphic `FeedItem` (at least `live_tonight` + `editorial` for this ticket) with `venueId?`, `venueNightId?`, `createdByUserId`, `origin`, `assisted`, `startsAt?`, `expiresAt`, `status`, typed `payload`.
- [ ] Backend: `live_tonight` items are created when an owner marks live (ticket 06 integration); `editorial` items are created by an `ADMIN`-only endpoint with publish time + expiry.
- [ ] Backend: ranking endpoint returns published, non-expired items for active launch-area venues + area-wide editorial, scored tier (tonight > this weekend > upcoming > recent > evergreen) then recency decay. Correctness of expiry is in the read filter, not a cron.
- [ ] Backend: the going-boost hook and `going_milestone` items are stubbed/absent here and wired when ticket 08 lands (whichever is second).
- [ ] Backend: `assisted` is set server-side from the principal + endpoint, never from a client field.
- [ ] Mobile: feed screen renders the server list verbatim — distinct cards for `live_tonight` and `editorial`; pull-to-refresh; paging; a designed empty state; last-feed read cache for offline display.
- [ ] Mobile: tapping a card opens its venue; `feed_opened` / `feed_item_viewed` events emitted (via the analytics client stub — full wiring is ticket 11).
- [ ] Demo: team publishes "Ce soir à Zone 4"; an owner marks live; a client opens the feed → the live card is above the editorial note; an editorial item dated yesterday does not appear.
