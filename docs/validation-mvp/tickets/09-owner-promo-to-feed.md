# 09: Owner posts a promo → feed + venue page, recorded organic

**What to build:** From the owner shell, a venue owner creates a promotion in under
ten seconds — a short title, a description, no photo yet. It appears in the Zone 4
feed and on the venue page. The backend records it as `origin = venue`,
`assisted = false`.

**Blocked by:** 07 (Zone 4 feed).

**Specs:** `../specs/03-feed.md` (promo type + owner create path), `../specs/13-mobile-owner-shell.md`, `../specs/11-mobile-feed-and-venue-discovery.md`.
**Seam:** backend HTTP e2e (provenance + feed membership); mobile notifier↔usecase
+ a create-promo widget test.

**Status:** ready-for-agent

- [ ] Backend: `FeedItem` `type = promo` with its typed payload (title, description, optional image ref — image is ticket 14); create-promo endpoint for `VENUE_OWNER` on their own venue → `origin = venue`, `assisted = false`, `createdByUserId` = the owner.
- [ ] Backend: the promo appears in the ranking endpoint (right tier) and is attached to the venue for the venue-page read; expiry handled like other time-bound items.
- [ ] Mobile owner: a fast create-promo form (title, description) reachable in one tap from the owner home; publish → returns to home with the item listed under recent activity.
- [ ] Mobile client: a distinct promo card renders in the feed and a promo section on the venue page.
- [ ] `promo_created` + `post_created` / `post_created_organically` events emitted.
- [ ] Demo: an owner creates "Happy hour -50% jusqu'à 23h"; it shows in the Zone 4 feed and on the venue page within seconds; the backend records `assisted = false`.
