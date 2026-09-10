# 10: Client follows a venue; followed content gets a feed lift

**What to build:** A client follows a venue from its page and can see "mes lieux
suivis" in their profile. Content from followed venues gets a bounded rank lift in
the Zone 4 feed — enough that following means something, not so much that the feed
becomes a pure follow list.

**Blocked by:** 07 (Zone 4 feed).

**Specs:** `../specs/05-follows.md`, `../specs/12-mobile-going-follow-and-notification-prefs.md`, `../specs/11-mobile-feed-and-venue-discovery.md`.
**Seam:** backend HTTP e2e (follow/unfollow + follower count + `followedVenueIds`);
mobile notifier↔usecase.

**Status:** ready-for-agent

- [ ] Backend: `Follow` record, unique active per (user, venue); follow/unfollow endpoints idempotent; unfollow keeps an event trail (soft-delete or an unfollow event).
- [ ] Backend: `followedVenueIds(userId)` + `isFollowing` for the feed ranking; follower count on the venue payload (count, not identities).
- [ ] Backend: the feed ranking endpoint applies a bounded lift to followed-venue items — a much busier non-followed venue can still outrank a followed one.
- [ ] Mobile: follow toggle on the venue page (optimistic, rollback on failure, idempotent); "mes lieux suivis" list in the profile with inline unfollow.
- [ ] `venue_followed` / `venue_unfollowed` events emitted.
- [ ] Demo: follow venue A; A's promo now sits above an equivalent non-followed venue B's promo in the feed; unfollow A → the lift is gone; "mes lieux suivis" reflects both actions.
